//
//  CustomerAuth
//  Copyright(c) 2024 Teal Mood LLC
//

import AuthenticationServices
import Foundation
import OAuth2
import SwiftUI
import UIKit

public typealias CustomerAuthTokenCallback = (OAuth2CodeGrant, OAuth2JSON?, Error?) -> Void

public class CustomerAuth {
  private var config: Configuration
  private var oauth2: OAuth2CodeGrant!
  private var callback: CustomerAuthTokenCallback

  public init(config: Configuration, callback: @escaping CustomerAuthTokenCallback) {
    self.config = config
    self.callback = callback
    oauth2 = buildOAuth(config: config)
    callback(oauth2, nil, nil)
  }

  open func buildOAuth(config: Configuration) -> OAuth2CodeGrant {
    let oauth2 = CustomerAuth.PrivateOAuth2CodeGrant(
      settings: config.oauth2Settings
    )
    oauth2.logger = OAuth2DebugLogger()
    oauth2.authConfig.authorizeEmbedded = true
    oauth2.authConfig.ui.useAuthenticationSession = true
    oauth2.authConfig.ui.prefersEphemeralWebBrowserSession = config.prefersEphemeralWebBrowserSession

    // Set `Configuration` inside pf `PrivateOAuth2CodeGrant`
    oauth2.config = config

    return oauth2
  }

  public var accessToken: String? {
    return oauth2.accessToken
  }

  public var idToken: String? {
    return oauth2.idToken
  }

  open func handleOpenURL(_ url: URL) {
    oauth2.handleRedirectURL(config.applicationSetup.redirectURI.rewrite(url))
  }

  public func logout() {
    oauth2.forgetTokens()
    let storage = HTTPCookieStorage.shared
    storage.cookies?.forEach { storage.deleteCookie($0) }
  }

  public func authorize(anchor: ASPresentationAnchor = .defaultForCustomerAuth) throws {
    if anchor === ASPresentationAnchor.nullWindow {
      assertionFailure("Could not find a window to present on")
      throw InvalidPresentationContext()
    }

    oauth2.authorizer.oauth2.authConfig.authorizeContext = anchor

    oauth2.authorize { [weak self] res, error in
      guard let self = self else {
        return
      }
      self.callback(self.oauth2, res, error)
    }
  }
}

extension CustomerAuth {
  struct InvalidPresentationContext: Swift.Error {}
}

extension CustomerAuth {
  class PrivateOAuth2CodeGrant: OAuth2CodeGrant {
    var config: Configuration!
    override func validateRedirectURL(_ redirect: URL) throws -> String {
      return try super.validateRedirectURL(config.applicationSetup.redirectURI.rewrite(redirect))
    }
  }
}

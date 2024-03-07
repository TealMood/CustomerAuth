//
//  CustomerAuth
//  Copyright(c) 2024 Teal Mood LLC
//

import AuthenticationServices
import Foundation
import OAuth2
import SwiftUI
import UIKit

public typealias CustomerAuthURI = String

public extension CustomerAuth {
  struct Configuration {
    public init(
      clientId: String,
      applicationEndpoints: ApplicationEndpoints,
      applicationSetup: ApplicationSetup,
      prefersEphemeralWebBrowserSession: Bool = false
    ) {
      self.clientId = clientId
      self.applicationEndpoints = applicationEndpoints
      self.applicationSetup = applicationSetup
      self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
    }

    /// `ClientID` field like `shp_4c342342-f72d-4b5c-bd25-8c1fcbaf1857`
    var clientId: String

    /// Configure these at Headless > Your App > Customer Accounts API > Manage > Application endpoints
    var applicationEndpoints: ApplicationEndpoints

    /// Configure these at Headless > Your App > Customer Accounts API > Manage > Application setup
    var applicationSetup: ApplicationSetup

    var prefersEphemeralWebBrowserSession: Bool
  }
}

public extension CustomerAuth.Configuration {
  struct ApplicationEndpoints {
    public init(authorize: CustomerAuthURI, token: CustomerAuthURI, logout: CustomerAuthURI) {
      self.authorize = authorize
      self.token = token
      self.logout = logout
    }

    public var authorize: CustomerAuthURI
    public var token: CustomerAuthURI
    public var logout: CustomerAuthURI
  }

  struct ApplicationSetup {
    public init(redirectURI: CustomerAuth.Configuration.RedirectURI, javascriptOrigin: CustomerAuthURI) {
      self.redirectURI = redirectURI
      self.javascriptOrigin = javascriptOrigin
    }

    /// Where the Shopify Customer Auth endpoint will take users
    var redirectURI: RedirectURI

    /// Provide value  in `Javascript origin(s) in Application setup`
    var javascriptOrigin: CustomerAuthURI
  }

  enum RedirectURI {
    public struct UniversalSchemeRedirect {
      public init(redirectURI: CustomerAuthURI, appSchemeURI: CustomerAuthURI) {
        self.redirectURI = redirectURI
        self.appSchemeURI = appSchemeURI
      }

      public var redirectURI: CustomerAuthURI
      public var appSchemeURI: CustomerAuthURI
    }

    case universalLink(CustomerAuthURI)
    case universalSchemeRedirect(UniversalSchemeRedirect)

    var redirectURI: CustomerAuthURI {
      switch self {
      case let .universalLink(uri):
        return uri
      case let .universalSchemeRedirect(schemeRedirect):
        return schemeRedirect.redirectURI
      }
    }
  }
}

public extension CustomerAuth.Configuration.RedirectURI {
  func rewrite(_ url: URL) -> URL {
    switch self {
    case .universalLink:
      return url
    case let .universalSchemeRedirect(schemeRedirect):
      return URL(
        string: url.absoluteString.replacingOccurrences(
          of: schemeRedirect.appSchemeURI,
          with: schemeRedirect.redirectURI
        )
      )!
    }
  }
}

extension CustomerAuth.Configuration {
  var oauth2Settings: OAuth2JSON {
    return [
      "client_id": clientId,
      "authorize_uri": applicationEndpoints.authorize,
      "token_uri": applicationEndpoints.token,
      "redirect_uris": [applicationSetup.redirectURI.redirectURI],
      "scope": "openid email https://api.customers.com/auth/customer.graphql",
      "use_pkce": true,
      "headers": [
        "Origin": applicationSetup.javascriptOrigin,
      ],
    ]
  }
}

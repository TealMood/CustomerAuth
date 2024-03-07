//
//  CustomerAuth
//  Copyright(c) 2024 Teal Mood LLC
//

import CustomerAuth
import Foundation
import SwiftUI

private struct ExampleStoreCustomerAuthKey: EnvironmentKey {
  static var defaultValue: ExampleStoreCustomerAuth {
    return .shared
  }
}

// 2. Extend the environment with our property
extension EnvironmentValues {
  var exampleStoreCustomerAuth: ExampleStoreCustomerAuth {
    get { self[ExampleStoreCustomerAuthKey.self] }
    set { self[ExampleStoreCustomerAuthKey.self] = newValue }
  }
}

extension CustomerAuth.Configuration {
  static var myAppConfig: Self {
    return
      .init(
        clientId: "shp_162795da-7a22-4a48-9759-e0ace70f4a89",
        applicationEndpoints: .init(
          authorize: "https://shopify.com/62716477577/auth/oauth/authorize",
          token: "https://shopify.com/62716477577/auth/oauth/token",
          logout: "https://shopify.com/62716477577/auth/logout"
        ),
        applicationSetup: .init(
          redirectURI: .universalSchemeRedirect(
            .init(
              redirectURI: "https://tinywich.ngrok.app/example-customer-app/auth/callback",
              appSchemeURI: "example-customer-app"
            )
          ),
          javascriptOrigin: "https://quickstart-f49b3c18.myshopify.com"
        ),
        prefersEphemeralWebBrowserSession: true
      )
  }
}

@Observable class ExampleStoreCustomerAuth {
  static var shared = ExampleStoreCustomerAuth()

  private var auth: CustomerAuth!
  var accessToken: String?

  init() {
    auth = .init(config: .myAppConfig, callback: { grant, _, _ in
      self.accessToken = grant.accessToken
    })
  }

  func authorize() {
    try? auth.authorize()
  }

  func logout() {
    auth.logout()
    accessToken = nil
  }
}

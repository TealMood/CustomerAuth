//
//  CustomerAuth
//  Copyright(c) 2024 Teal Mood LLC
//

import CustomerAuth
import SwiftUI

@main
struct CustomerAuthExampleAppApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }.environment(\.exampleStoreCustomerAuth, .shared)
  }
}

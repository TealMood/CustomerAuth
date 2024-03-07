//
//  CustomerAuth
//  Copyright(c) 2024 Teal Mood LLC
//

import CustomerAuth
import SwiftUI

struct ContentView: View {
  @Environment(\.exampleStoreCustomerAuth) var customerAuth

  func AccountButton() -> some View {
    Group {
      if let token = customerAuth.accessToken {
        Text("Access token").bold()
        Text(token)

        Spacer()

        Button(action: {
          customerAuth.logout()
        }, label: {
          Text("Sign-out")
        }).buttonStyle(.borderedProminent)
      } else {
        Button(action: {
          customerAuth.authorize()
        }, label: {
          Text("Sign-in")
        }).buttonStyle(.borderedProminent)
      }
    }
  }

  var body: some View {
    VStack {
      Spacer()

      Image(systemName: "cart")
        .imageScale(.large)
        .foregroundStyle(.tint)

      Text("CustomerAuth")
        .font(.title)

      Spacer()

      AccountButton()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}

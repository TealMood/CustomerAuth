//
//  CustomerAuth
//  Copyright(c) 2024 Teal Mood LLC
//

import AuthenticationServices
import Foundation

extension ASPresentationAnchor {
  static let nullWindow = UIWindow()

  private static var keyWindow: UIWindow? {
    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene else { continue }
      for window in windowScene.windows where window.isKeyWindow {
        return window
      }
    }
    return nil
  }

  public static var defaultForCustomerAuth: ASPresentationAnchor {
    keyWindow ?? nullWindow
  }
}

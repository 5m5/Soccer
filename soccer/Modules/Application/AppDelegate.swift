//
//  AppDelegate.swift
//  soccer
//
//  Created by Mikhail Andreev on 31.08.2021.
//

import UIKit
import Firebase

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Internal Properties
  var window: UIWindow?

  // MARK: - Internal Methods
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()
    makeNavigationBarTransparent()
    navigationBarFont()
    tabBarFont()
    backButton()

    window = UIWindow()
    window?.rootViewController = TabBarController()
    window?.makeKeyAndVisible()
    return true
  }

}

// MARK: - Private Methods
private extension AppDelegate {
  func makeNavigationBarTransparent() {
    let appearance = UINavigationBar.appearance()
    appearance.setBackgroundImage(UIImage(), for: .default)
    appearance.shadowImage = UIImage()
    appearance.isTranslucent = true
  }

  func navigationBarFont() {
    let font = UIFont(name: "Legacy", size: 20) as Any
    UINavigationBar.appearance().titleTextAttributes = [.font: font]
  }

  func tabBarFont() {
    guard let font = UIFont(name: "Staubach", size: 12) else { return }
    UITabBarItem.appearance().setTitleTextAttributes([.font: font], for: .normal)
  }

  func backButton() {
    UINavigationBar.appearance().tintColor = .label
  }

}

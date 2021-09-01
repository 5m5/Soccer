//
//  AppDelegate.swift
//  soccer
//
//  Created by Mikhail Andreev on 31.08.2021.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Internal Properties
  var window: UIWindow?

  // MARK: - Private Properties

  // MARK: - Internal Methods
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    window = UIWindow()
    let appCoordinator = AppCoordinator()
    appCoordinator.start()
    window?.rootViewController = appCoordinator.presenter
    window?.makeKeyAndVisible()
    return true
  }

}

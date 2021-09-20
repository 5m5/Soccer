//
//  NavigationBarPage.swift
//  SoccerUITests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

final class NavigationBarPage: Page {

  var app: XCUIApplication

  var navigationBars: XCUIElement { app.navigationBars["Bayern Munich"] }

  init(app: XCUIApplication) {
    self.app = app
  }

}

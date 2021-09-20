//
//  TabBarPage.swift
//  SoccerUITests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

final class TabBarPage: Page {
  var app: XCUIApplication
  private var tabBarItem: XCUIElement { app.tabBars.buttons["Teams"] }

  required init(app: XCUIApplication) {
    self.app = app
  }

  func tapTeamsTab() -> SearchTeamPage {
    if tabBarItem.waitForExistence(timeout: 10) {
      tabBarItem.tap()
    }
    return SearchTeamPage(app: app)
  }

}

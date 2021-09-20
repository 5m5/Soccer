//
//  TeamDetailsPage.swift
//  SoccerUITests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

final class TeamDetailsPage: Page {
  var app: XCUIApplication

  private var teamTable: XCUIElement { app.tables.staticTexts["Bayern Munich"] }

  init(app: XCUIApplication) {
    self.app = app
  }

  func tapTable() -> NavigationBarPage {
    if teamTable.waitForExistence(timeout: 10) {
      teamTable.tap()
    }
    return NavigationBarPage(app: app)
  }

}

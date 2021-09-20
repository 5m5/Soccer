//
//  SearchTeamPage.swift
//  SoccerUITests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

final class SearchTeamPage: Page {
  var app: XCUIApplication

  private var searchField: XCUIElement {
    app.navigationBars["Teams"].searchFields["Search teams"]
  }

  required init(app: XCUIApplication) {
    self.app = app
  }

  func tapTeamName() -> TeamDetailsPage {
    if searchField.waitForExistence(timeout: 10) {
      searchField.tap()
      searchField.typeText("Bayern")
    }
    return TeamDetailsPage(app: app)
  }

}

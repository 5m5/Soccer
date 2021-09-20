//
//  SoccerUITests.swift
//  SoccerUITests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

final class SoccerUITests: XCTestCase {

  func test() {
    let app = XCUIApplication()
    app.launch()
    let tabBarPage = TabBarPage(app: app)
    let searchTeamsPage = tabBarPage.tapTeamsTab()
    let teamDetailsPage = searchTeamsPage.tapTeamName()
    let navigationBarPage = teamDetailsPage.tapTable()

    XCTAssertTrue(navigationBarPage.navigationBars.exists )
  }

}

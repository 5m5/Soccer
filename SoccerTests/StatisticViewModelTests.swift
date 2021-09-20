//
//  StatisticViewModelTests.swift
//  SoccerTests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

@testable import Soccer

final class StatisticViewModelTests: XCTestCase {

  var sut: StatisticViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()

    let data = try getData(fromJSON: "MatchResponse")
    let response = try JSONDecoder().decode(MatchResponse.self, from: data)
    sut = StatisticViewModel(matchResponse: response)
    let parser = JSONParserMock<StatisticResult>()
    parser.data = try getData(fromJSON: "StatisticResult")
    sut.parser = parser
  }

  override func tearDownWithError() throws {
    sut = nil

    try super.tearDownWithError()
  }

  func testTeamNames() {
    let tuple = (home: "Barcelona", away: "Real Sociedad")
    XCTAssertTrue(tuple == sut.teamNames)
  }

  func testScoreLabel() {
    XCTAssertEqual("4 : 2", sut.scoreLabel)
  }

  func testMatchDateString() {
    XCTAssertEqual("15 August 2021 21:00", sut.matchDateString)
  }

  func testStatisticCount() {
    let exp = expectation(description: "Test after 3 seconds")
    sut.fetchStatistic {
      exp.fulfill()
    }
    waitForExpectations(timeout: 3, handler: nil)
    XCTAssertEqual(sut.statisticsCount, 16)
  }

  func testTableViewShouldBeHidden() {
    sut.statisticsCount = 0
    XCTAssertTrue(sut.isTableViewHidden)
  }

  func testTableViewShouldNotBeHidden() {
    sut.statisticsCount = 1
    XCTAssertFalse(sut.isTableViewHidden)
  }

}

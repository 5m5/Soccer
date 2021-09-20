//
//  MainViewModelTests.swift
//  SoccerTests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

@testable import Soccer

final class MainViewModelTests: XCTestCase {

  var sut: MainViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()

    sut = MainViewModel()

    let leagueParser = JSONParserMock<LeagueResult>()
    leagueParser.data = try getData(fromJSON: "LeagueResult")
    sut.leaguesParser = leagueParser

    let matchesParser = JSONParserMock<MatchResult>()
    matchesParser.data = try getData(fromJSON: "MatchResult")
    sut.matchesParser = matchesParser
  }

  override func tearDownWithError() throws {
    sut = nil

    try super.tearDownWithError()
  }

  func testViewModelCount() {
    // arrange
    let indexPath = IndexPath(row: 1, section: 0)
    let exp = expectation(description: "Test after 3 seconds")
    // act
    sut.fetchLeagues { [unowned self] in
      self.sut.collectionView(didSelectItemAt: indexPath) {
        exp.fulfill()
      }
    }
    waitForExpectations(timeout: 3, handler: nil)
    // assert
    XCTAssertEqual(sut.leaguesCount, 3)
    XCTAssertEqual(sut.matchesCount, 2)
    XCTAssertEqual(sut.leagueName, "Ligue 1")
  }

}

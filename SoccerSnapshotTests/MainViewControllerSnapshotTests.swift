//
//  MainViewControllerSnapshotTests.swift
//  SoccerSnapshotTests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest
import SnapshotTesting

@testable import Soccer

class MainViewControllerSnapshotTests: XCTestCase {

  func testSnapshotViewController() {
    let sut = MainViewController(viewModel: MainViewModel())

    assertSnapshot(matching: sut, as: .image(on: .iPhoneSe))
  }

}

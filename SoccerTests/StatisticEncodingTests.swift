//
//  StatisticEncodingTests.swift
//  SoccerTests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

@testable import Soccer

final class StatisticEncodingTests: XCTestCase {

  func testValueShouldBeInt() {
    let data = """
      {
        "type": "Int",
        "value": 80
      }
      """.data(using: .utf8)!

    let statistic = try! JSONDecoder().decode(Statistic.self, from: data)

    switch statistic.value {
    case .integer(let value): XCTAssertEqual(value, 80)
    default: XCTFail("Value should be Int")
    }

  }

  func testValueShouldBeString() {
    let data = """
      {
        "type": "String",
        "value": "Some"
      }
      """.data(using: .utf8)!

    let statistic = try! JSONDecoder().decode(Statistic.self, from: data)

    switch statistic.value {
    case .string(let value): XCTAssertEqual(value, "Some")
    default: XCTFail("Value should be String")
    }
  }

  func testValueShouldBeNil() {
    let data = """
      {
        "type": "String",
        "value": null
      }
      """.data(using: .utf8)!

    let statistic = try! JSONDecoder().decode(Statistic.self, from: data)

    switch statistic.value {
    case .null: XCTAssert(true)
    default: XCTFail("Value should be nil")
    }
  }

}

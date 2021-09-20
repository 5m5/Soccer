//
//  URLRequestTests.swift
//  SoccerTests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

@testable import Soccer

final class URLRequestTests: XCTestCase {
  func testAppendQueryItem() {
    // arrange
    let url = URL(string: "https://www.google.ru/")!
    var urlRequest = URLRequest(url: url)
    let queryItem = URLQueryItem(name: "hl", value: "ru")

    // act
    let stringToTest = urlRequest.append(queryItem: queryItem).url!.absoluteString

    // assert
    XCTAssertTrue(stringToTest == "https://www.google.ru/?hl=ru")
  }

}

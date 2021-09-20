//
//  JSONParserMock.swift
//  Soccer
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

@testable import Soccer

class JSONParserMock<T: Codable>: JSONParser<T> {

  var data: Data!

  override func fetch(urlRequest: URLRequest, completion: @escaping ResultCompletion<T>) {
    let decodedData = try! JSONDecoder().decode(T.self, from: data)
    completion(.success(decodedData))
  }

}

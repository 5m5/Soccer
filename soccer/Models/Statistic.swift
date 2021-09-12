//
//  Statistic.swift
//  soccer
//
//  Created by Mikhail Andreev on 11.09.2021.
//

import Foundation

// MARK: - Level 1
// MARK: - StatisticResult
struct StatisticResult: Codable {
  let response: [StatisticResponse]
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case response
    case count = "results"
  }

}

// MARK: - Level 2
// MARK: - StatisticResponse
struct StatisticResponse: Codable {
  let team: Team
  let statistics: [Statistic]
}

// MARK: - Level 3
// MARK: - Statistic
struct Statistic: Codable {
  let type: String
  let value: Value
}

enum Value: Codable {
  case integer(Int)
  case string(String)
  case null

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let x = try? container.decode(Int.self) {
      self = .integer(x)
      return
    }
    if let x = try? container.decode(String.self) {
      self = .string(x)
      return
    }
    if container.decodeNil() {
      self = .null
      return
    }

    throw DecodingError.typeMismatch(
      Value.self,
      DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Wrong type for Value"
      )
    )
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .integer(let x):
      try container.encode(x)
    case .string(let x):
      try container.encode(x)
    case .null:
      try container.encodeNil()
    }
  }

}

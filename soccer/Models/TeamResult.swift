//
//  TeamResult.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import Foundation

// MARK: - Level 1
// MARK: - TeamResult
struct TeamResult: Codable {
  let response: [TeamResponse]
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case response
    case count = "results"
  }

}

// MARK: - Level 2
// MARK: - TeamResponse
struct TeamResponse: Codable {
  let team: Team
  let stadium: Stadium
  var players: [Player]?

  private enum CodingKeys: String, CodingKey {
    case team
    case stadium = "venue"
    case players
  }
}

struct Stadium: Codable {
  let id: Int?
  let name: String?
  let address: String?
  let city: String?
}

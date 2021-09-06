//
//  Match.swift
//  soccer
//
//  Created by Mikhail Andreev on 05.09.2021.
//

import Foundation

// MARK: - Top level
// MARK: - MatchResult
struct MatchResult: Codable {
  let response: [MatchResponse]
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case response
    case count = "results"
  }

}

// MARK: - Level 1
// MARK: - MatchResponse
struct MatchResponse: Codable {
  let match: Match
  let teams: TeamResponse

  private enum CodingKeys: String, CodingKey {
    case match = "fixture"
    case teams
  }
}

// MARK: - Level 2
// MARK: - Match
struct Match: Codable {
  let id: Int
  let timestamp: TimeInterval
}

// MARK: - TeamResponse
struct TeamResponse: Codable {
  let home: Team
  let away: Team
}

// MARK: - Level 3
// MARK: - Team
struct Team: Codable {
  let id: Int
  let name: String
  let logo: String
  let winner: Bool?
}

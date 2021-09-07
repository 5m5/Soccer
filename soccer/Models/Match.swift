//
//  Match.swift
//  soccer
//
//  Created by Mikhail Andreev on 05.09.2021.
//

import Foundation

// MARK: - Level 1
// MARK: - MatchResult
struct MatchResult: Codable {
  let response: [MatchResponse]
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case response
    case count = "results"
  }

}

// MARK: - Level 2
// MARK: - MatchResponse
struct MatchResponse: Codable {
  let match: Match
  let teams: TeamResponse
  let goals: Goals

  private enum CodingKeys: String, CodingKey {
    case match = "fixture"
    case teams
    case goals
  }

}

// MARK: - Level 3
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

// MARK: - Goals
struct Goals: Codable {
  let home: Int?
  let away: Int?
}

// MARK: - Level 4
// MARK: - Team
struct Team: Codable {
  let id: Int
  let name: String
  let logo: String
  let winner: Bool?
}

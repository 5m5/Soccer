//
//  League.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

// MARK: - Level 1
// MARK: - LeagueResult
struct LeagueResult: Codable {
  let response: [LeagueResponse]
  let count: Int

  private enum CodingKeys: String, CodingKey {
    case response
    case count = "results"
  }

}

// MARK: - Level 2
// MARK: - LeagueResponse
struct LeagueResponse: Codable {
  let league: League
  let seasons: [Season]
}

// MARK: - Level 3
// MARK: - League
struct League: Codable {
  let id: Int
  let name: String
  let type: String
  let logo: String?

  lazy var logoURL: URL? = { .from(string: logo) }()
}

// MARK: - Season
struct Season: Codable {
  let year: Int
}

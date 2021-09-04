//
//  League.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

struct League: Codable {
  let id: Int
  let name: String
  let type: String
  let logo: String?

  lazy var logoURL: URL? = { .from(string: logo) }()
}

struct Season: Codable {
  let year: Int
}

struct LeagueResponse: Codable {
  let league: League
  let seasons: [Season]
}

struct LeagueResult: Codable {
  let response: [LeagueResponse]
}

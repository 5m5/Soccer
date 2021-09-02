//
//  League.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

struct League: Codable {
  var key: String
  var name: String
  var countryKey: String
  var countryName: String
  var leagueLogoStringPath: String?
  var countryLogoStringPath: String?

  lazy var leagueLogoURL: URL? = { .from(string: leagueLogoStringPath) }()
  lazy var countryLogoURL: URL? = { .from(string: countryLogoStringPath) }()

  private enum CodingKeys: String, CodingKey {
    case key = "league_key"
    case name = "league_name"
    case countryKey = "country_key"
    case countryName = "country_name"
    case leagueLogoStringPath = "league_logo"
    case countryLogoStringPath = "country_logo"
  }
}

struct LeagueResponse: Codable {
  var result: [League]
}

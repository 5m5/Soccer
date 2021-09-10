//
//  APIConfig.swift
//  soccer
//
//  Created by Mikhail Andreev on 10.09.2021.
//

import Foundation

enum EndPoints: String {
  case leagues = "leagues"
  case matches = "fixtures"
}

enum APIConfig {
  static let apiKey = (
    value: "2328f44d0dmsh6aabaae99954adcp14f0bcjsneb7df30c356b",
    key: "x-rapidapi-key"
  )

  static let host = (value: "api-football-v1.p.rapidapi.com", key: "x-rapidapi-host")
  static let base = "https://api-football-v1.p.rapidapi.com/v3/"
}

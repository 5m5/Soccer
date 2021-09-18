//
//  Team.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import Foundation

// MARK: - Team
struct Team: Codable {
  let id: Int
  let name: String
  let country: String?
  let logo: String
}

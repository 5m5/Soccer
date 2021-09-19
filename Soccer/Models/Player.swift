//
//  Player.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//

import Foundation

// MARK: - Level 1
// MARK: - PlayerResult
struct PlayerResult: Codable {
  let response: [PlayerResponse]
}

// MARK: - Level 2
// MARK: - PlayerResponse
struct PlayerResponse: Codable {
  let players: [Player]
}

// MARK: - Level 3
// MARK: - Player
struct Player: Codable {
  let id: Int
  let name: String?
  let age: Int?
  let number: Int?
  let position: String?
  let photo: String?
}

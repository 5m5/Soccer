//
//  PlayerBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//

import Foundation

// MARK: - Protocol
protocol PlayerBuilderProtocol: URLBuilderProtocol {
  func with(teamID: Int) -> Self
}

// MARK: - Implementation
final class PlayerBuilder: PlayerBuilderProtocol {
  var urlRequest: URLRequest

  init(urlRequest: URLRequest) {
    self.urlRequest = urlRequest
    self.urlRequest.url?.appendPathComponent(EndPoints.players)
  }

  @discardableResult
  func with(teamID: Int) -> Self {
    let queryItem = URLQueryItem(name: "team", value: "\(teamID)")
    urlRequest.append(queryItem: queryItem)
    return self
  }

}

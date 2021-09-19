//
//  StatisticBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 11.09.2021.
//

import Foundation

// MARK: - Protocol
protocol StatisticBuilderProtocol: URLBuilderProtocol {
  func with(matchId: Int) -> Self
}

// MARK: - Implementation
final class StatisticBuilder: StatisticBuilderProtocol {
  var urlRequest: URLRequest

  init(urlRequest: URLRequest) {
    self.urlRequest = urlRequest
    self.urlRequest.url?.appendPathComponent(EndPoints.statistics)
  }

  @discardableResult
  func with(matchId: Int) -> Self {
    let queryItem = URLQueryItem(name: "fixture", value: "\(matchId)")
    urlRequest.append(queryItem: queryItem)
    return self
  }

}

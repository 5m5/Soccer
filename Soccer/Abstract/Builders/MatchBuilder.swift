//
//  MatchBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 10.09.2021.
//

import Foundation

// MARK: - Protocol
protocol MatchBuilderProtocol: URLBuilderProtocol {
  func with(seasonYear: Int) -> Self
  func with(leagueID: Int) -> Self
}

// MARK: - Implementation
final class MatchBuilder: MatchBuilderProtocol {

  var urlRequest: URLRequest

  init(urlRequest: URLRequest) {
    self.urlRequest = urlRequest
    self.urlRequest.url?.appendPathComponent(EndPoints.matches)

    // Пока отображаем только завершившиеся матчи
    let queryItem = URLQueryItem(name: "status", value: "FT")
    self.urlRequest.append(queryItem: queryItem)

    let timezone = TimeZone.current.identifier
    let timezoneQueryItem = URLQueryItem(name: "timezone", value: timezone)
    self.urlRequest.append(queryItem: timezoneQueryItem)
  }

  @discardableResult
  func with(seasonYear: Int) -> Self {
    let queryItem = URLQueryItem(name: "season", value: "\(seasonYear)")
    urlRequest.append(queryItem: queryItem)
    return self
  }

  @discardableResult
  func with(leagueID: Int) -> Self {
    let queryItem = URLQueryItem(name: "league", value: "\(leagueID)")
    urlRequest.append(queryItem: queryItem)
    return self
  }

}

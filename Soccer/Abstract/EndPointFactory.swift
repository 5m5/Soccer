//
//  EndPointFactory.swift
//  soccer
//
//  Created by Mikhail Andreev on 10.09.2021.
//

import Foundation

// MARK: - Protocol
protocol EndPointFactoryProtocol: AnyObject {
  init()
  func leagues() -> LeagueBuilderProtocol
  func matches() -> MatchBuilderProtocol
  func statistics() -> StatisticBuilderProtocol
  func teams() -> TeamBuilderProtocol
  func players() -> PlayerBuilderProtocol
}

// MARK: - Implementation
final class EndPointFactory: EndPointFactoryProtocol {

  private var urlRequest: URLRequest

  init() {
    guard let url = URL(string: APIConfig.base) else { preconditionFailure("Can't unwrap url") }
    var urlRequest = URLRequest(url: url)
    urlRequest.setValue(APIConfig.apiKey.value, forHTTPHeaderField: APIConfig.apiKey.key)
    urlRequest.setValue(APIConfig.host.value, forHTTPHeaderField: APIConfig.host.key)
    self.urlRequest = urlRequest
  }

  func leagues() -> LeagueBuilderProtocol {
    LeagueBuilder(urlRequest: urlRequest)
  }

  func matches() -> MatchBuilderProtocol {
    MatchBuilder(urlRequest: urlRequest)
  }

  func statistics() -> StatisticBuilderProtocol {
    StatisticBuilder(urlRequest: urlRequest)
  }

  func teams() -> TeamBuilderProtocol {
    TeamBuilder(urlRequest: urlRequest)
  }

  func players() -> PlayerBuilderProtocol {
    PlayerBuilder(urlRequest: urlRequest)
  }

}

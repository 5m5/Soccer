//
//  URLBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

enum EndPoints: String {
  case leagues = "leagues"
  case matches = "fixtures"
}

private enum ApiConfig {
  static let apiKey = (
    value: "2328f44d0dmsh6aabaae99954adcp14f0bcjsneb7df30c356b",
    key: "x-rapidapi-key"
  )

  static let host = (value: "api-football-v1.p.rapidapi.com", key: "x-rapidapi-host")
  static let base = "https://api-football-v1.p.rapidapi.com/v3/"
}

protocol URLBuilding: AnyObject {
  var urlRequest: URLRequest { get }

  func with(endPoint: EndPoints) -> Self
  func with(seasonYear: Int) -> Self
  func with(leagueID: Int) -> Self
}

final class URLBuilder {

  var urlRequest: URLRequest

  init() {
    guard let url = URL(string: ApiConfig.base) else { preconditionFailure("Can't unwrap url") }
    urlRequest = URLRequest(url: url)
    urlRequest.setValue(ApiConfig.apiKey.value, forHTTPHeaderField: ApiConfig.apiKey.key)
    urlRequest.setValue(ApiConfig.host.value, forHTTPHeaderField: ApiConfig.host.key)
  }

}

extension URLBuilder: URLBuilding {
  @discardableResult
  func with(endPoint: EndPoints) -> Self {
    urlRequest.url?.appendPathComponent(endPoint.rawValue)
    return self
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

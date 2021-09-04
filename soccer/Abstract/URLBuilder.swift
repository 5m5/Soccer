//
//  URLBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

enum EndPoints: String {
  case leagues = "leagues"
  case teams = "Teams"
  case livescore = "Livescore"
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
    urlRequest.url?.appendPathComponent(EndPoints.leagues.rawValue)
    //guard let url = urlRequest.url else { return self } // TODO: Возможно, обернуть в precondition
    var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
    // Показываем только те лиги, сезон в которых уже начался
    let queryItem = URLQueryItem(name: "current", value: "true")
    components?.queryItems?.append(queryItem)
    return self
  }

}

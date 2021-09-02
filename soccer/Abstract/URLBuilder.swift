//
//  URLBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

enum EndPoints: String {
  case leagues = "Leagues"
  case teams = "Teams"
  case livescore = "Livescore"
}

protocol URLBuilding: AnyObject {
  func with(endPoint: EndPoints) -> Self
}

final class URLBuilder {
  var url: URL? { _components?.url }

  private var _components = URLComponents(string: "\(ApiConfig.base)?APIkey=\(ApiConfig.apiKey)")

  private func queryItem(value: EndPoints) -> URLQueryItem {
    URLQueryItem(name: "met", value: value.rawValue)
  }

}

extension URLBuilder: URLBuilding {
  @discardableResult
  func with(endPoint: EndPoints) -> Self {
    let queryItem = queryItem(value: endPoint)
    _components?.queryItems?.append(queryItem)
    return self
  }

}

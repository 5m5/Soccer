//
//  TeamBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import Foundation

// MARK: - Protocol
protocol TeamBuilderProtocol: URLBuilderProtocol {
  func with(name: String) -> Self
}

// MARK: - Implementation
final class TeamBuilder: TeamBuilderProtocol {
  var urlRequest: URLRequest

  init(urlRequest: URLRequest) {
    self.urlRequest = urlRequest
    self.urlRequest.url?.appendPathComponent(EndPoints.teams)
  }

  @discardableResult
  func with(name: String) -> Self {
    let queryItem = URLQueryItem(name: "search", value: name)
    urlRequest.append(queryItem: queryItem)
    return self
  }

}

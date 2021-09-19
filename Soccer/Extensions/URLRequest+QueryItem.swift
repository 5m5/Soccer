//
//  URLRequest+QueryItem.swift
//  soccer
//
//  Created by Mikhail Andreev on 06.09.2021.
//

import Foundation

extension URLRequest {
  @discardableResult
  mutating func append(queryItem: URLQueryItem) -> Self {
    guard
      let url = url,
      var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return self }

    if components.queryItems != nil {
      components.queryItems?.append(queryItem)
    } else {
      components.queryItems = [queryItem]
    }

    self.url = components.url
    return self
  }

}

//
//  LeagueBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 10.09.2021.
//

import Foundation

// MARK: - Protocol
protocol LeagueBuilderProtocol: URLBuilderProtocol {

}

// MARK: - Implementation
final class LeagueBuilder: LeagueBuilderProtocol {

  var urlRequest: URLRequest

  init(urlRequest: URLRequest) {
    self.urlRequest = urlRequest
    self.urlRequest.url?.appendPathComponent(EndPoints.leagues)
  }

}

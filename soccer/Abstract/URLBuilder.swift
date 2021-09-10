//
//  URLBuilder.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

protocol URLBuilderProtocol: AnyObject {
  var urlRequest: URLRequest { get }
  init(urlRequest: URLRequest)
}

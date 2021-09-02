//
//  URL+FromOptionalString.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

extension URL {
  static func from(string: String?) -> Self? {
    guard let string = string else { return nil }

    return .init(string: string)
  }
}

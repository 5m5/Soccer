//
//  DefaultsWrapper.swift
//  Soccer
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import Foundation

@propertyWrapper
struct DefaultsWrapper<T: Codable> {

  // MARK: - Internal Properties

  var wrappedValue: T? {
    get { standard.object(forKey: key) as? T }
    set { standard.setValue(newValue, forKey: key) }
  }

  // MARK: - Private Properties

  private let key: String
  private let standard = UserDefaults.standard

  // MARK: - Lifecycle

  init(key: String) {
    self.key = key
  }

}

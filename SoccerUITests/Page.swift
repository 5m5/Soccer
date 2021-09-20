//
//  Page.swift
//  SoccerUITests
//
//  Created by Mikhail Andreev on 20.09.2021.
//

import XCTest

protocol Page {
  var app: XCUIApplication { get }

  init(app: XCUIApplication)
}

//
//  MatchProxy.swift
//  soccer
//
//  Created by Mikhail Andreev on 11.09.2021.
//

import Foundation

/// Структура для передачи только нужных данных между контроллерами, чтобы не ходить в сеть дважды
struct MatchProxy {
  var imagesData: (home: Data?, away: Data?)
  var teamNames: (home: String, away: String)
  var scoreLabelText: String
}

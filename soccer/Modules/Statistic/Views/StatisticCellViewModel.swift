//
//  StatisticTableViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 12.09.2021.
//

import Foundation

protocol StatisticCellViewModelProtocol: AnyObject {
  /// Значение параметра статистики для домашней команды
  var statisticHome: String { get }
  /// Название параметра статистики
  var statisticType: String { get }
  /// Значение параметра статистики для гостевой команды
  var statisticAway: String { get }

  init(statisticHome: String, statisticType: String, statisticAway: String)
}

final class StatisticCellViewModel: StatisticCellViewModelProtocol {

  static let identifier = "statisticCell"

  var statisticHome: String
  var statisticType: String
  var statisticAway: String

  init(statisticHome: String, statisticType: String, statisticAway: String) {
    self.statisticHome = statisticHome
    self.statisticType = statisticType
    self.statisticAway = statisticAway
  }

}

//
//  StatisticViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 11.09.2021.
//

import Foundation

protocol StatisticViewModelProtocol: AnyObject {
  var matchId: Int { get }
  init(matchId: Int)
}

final class StatisticViewModel: StatisticViewModelProtocol {
  var matchId: Int

  init(matchId: Int) {
    self.matchId = matchId
  }

}

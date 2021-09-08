//
//  LeagueCellViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import Foundation

protocol LeagueCellViewModelProtocol: AnyObject {
  var league: League { get }
  var imageData: Data? { get }
  init(league: League)
}

final class LeagueCellViewModel: LeagueCellViewModelProtocol {
  static let identifier = "leagueCell"

  var league: League
  var imageData: Data? { ImageDataService.shared.imageData(urlString: league.logo) }

  init(league: League) {
    self.league = league
  }

}

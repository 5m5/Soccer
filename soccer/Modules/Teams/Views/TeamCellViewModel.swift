//
//  TeamCellViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 14.09.2021.
//

import Foundation

protocol TeamCellViewModelProtocol: AnyObject {
  var team: Team { get }
  var teamName: String { get }
  var countryName: String { get }
  var imageData: Data? { get }
  init(team: Team)
}

final class TeamCellViewModel: TeamCellViewModelProtocol {
  static let identifier = "teamCell"

  var team: Team
  var teamName: String { team.name }
  var countryName: String { team.country ?? "" }
  var imageData: Data? { ImageDataService.shared.imageData(urlString: team.logo) }

  init(team: Team) {
    self.team = team
  }

}

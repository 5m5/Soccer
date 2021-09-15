//
//  MatchCellViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 04.09.2021.
//

import Foundation

protocol MatchCellViewModelProtocol: AnyObject {
  var matchResponse: MatchResponse { get }
  var imagesData: (home: Data?, away: Data?) { get }
  var teamNames: (home: String, away: String) { get }
  var scoreLabelText: String { get }
  var defaultImageName: String { get }
  init(matchResponse: MatchResponse)
}

final class MatchCellViewModel: MatchCellViewModelProtocol {

  static let identifier = "matchCell"

  var matchResponse: MatchResponse

  var imagesData: (home: Data?, away: Data?) {
    let teams = matchResponse.teams
    let imageService = ImageDataService.shared
    let home = imageService.imageData(urlString: teams.home.logo)
    let away = imageService.imageData(urlString: teams.away.logo)
    return (home: home, away: away)
  }

  var teamNames: (home: String, away: String) {
    let teams = matchResponse.teams
    return (home: teams.home.name, away: teams.away.name)
  }

  var defaultImageName = "football_club"

  var scoreLabelText: String {
    let goals = matchResponse.goals
    let homeTeamGoals = goals.home ?? 0
    let awayTeamGoals = goals.away ?? 0
    return "\(homeTeamGoals) : \(awayTeamGoals)"
  }

  init(matchResponse: MatchResponse) {
    self.matchResponse = matchResponse
  }

}

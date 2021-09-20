//
//  StatisticViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 11.09.2021.
//

import Foundation

protocol StatisticViewModelProtocol: AnyObject {
  var coordinator: StatisticCoordinator? { get }
  var matchResponse: MatchResponse { get }
  var statistics: [StatisticResponse] { get }
  var statisticsCount: Int { get }
  var imagesData: (home: Data?, away: Data?) { get }
  var defaultImageName: String { get }
  var teamNames: (home: String, away: String) { get }
  var scoreLabel: String { get }
  var matchDateString: String { get }
  var isTableViewHidden: Bool { get }
  var parser: JSONParser<StatisticResult> { get }

  init(matchResponse: MatchResponse)

  func fetchStatistic(completion: @escaping () -> Void)
  func statisticCellViewModel(for indexPath: IndexPath) -> StatisticCellViewModelProtocol
}

final class StatisticViewModel: StatisticViewModelProtocol {
  // Сделать weak, если возникнет необходимость иметь ViewModel как поле класса координатора
  var coordinator: StatisticCoordinator?
  var matchResponse: MatchResponse
  var statisticResponse: [StatisticResponse] = []

  var imagesData: (home: Data?, away: Data?) {
    let teams = matchResponse.teams
    let imageService = ImageDataService.shared
    let home = imageService.imageData(urlString: teams.home.logo)
    let away = imageService.imageData(urlString: teams.away.logo)
    return (home: home, away: away)
  }

  var defaultImageName = "football_club"

  var teamNames: (home: String, away: String) {
    let teams = matchResponse.teams
    return (home: teams.home.name, away: teams.away.name)
  }

  var scoreLabel: String {
    let goals = matchResponse.goals
    let home = goals.home ?? 0
    let away = goals.away ?? 0
    return "\(home) : \(away)"
  }

  var matchDateString: String {
    let date = Date(timeIntervalSince1970: matchResponse.match.timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
    return dateFormatter.string(from: date)
  }

  var isTableViewHidden: Bool { statisticsCount == 0 }

  init(matchResponse: MatchResponse) {
    self.matchResponse = matchResponse
  }

  var statistics: [StatisticResponse] = []
  var statisticsCount = 0

  var parser = JSONParser<StatisticResult>()

  func fetchStatistic(completion: @escaping () -> Void) {

    let matchId = matchResponse.match.id
    let urlRequest = EndPointFactory().statistics().with(matchId: matchId).urlRequest

    parser.fetch(urlRequest: urlRequest) { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          let statistics = result.response
          if statistics.count < 2 { completion(); return }
          self.statistics = statistics
          self.statisticsCount = max(statistics[0].statistics.count, statistics[1].statistics.count)
          completion()
        }
      case .failure(let error):
        if error is NetworkError {
          print(error)
        } else {
          print(error.localizedDescription)
        }
      }
    }
  }

  func statisticCellViewModel(for indexPath: IndexPath) -> StatisticCellViewModelProtocol {
    let index = indexPath.row
    let homeStatistic = statistics[0].statistics[index]
    let awayStatistic = statistics[1].statistics[index]

    let homeValue = string(from: homeStatistic.value)
    let awayValue = string(from: awayStatistic.value)

    return StatisticCellViewModel(
      statisticHome: homeValue,
      statisticType: homeStatistic.type,
      statisticAway: awayValue
    )
  }

}

private extension StatisticViewModel {
  func string(from value: Value) -> String {
    switch value {
    case .integer(let value):
      return "\(value)"
    case .string(let value):
      return value
    case .null:
      return "0"
    }
  }

}

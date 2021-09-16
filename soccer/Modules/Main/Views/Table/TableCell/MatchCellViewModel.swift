//
//  MatchCellViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 04.09.2021.
//

import Foundation

protocol MatchCellViewModelProtocol: AnyObject {
  var matchResponse: MatchResponse { get }
  var homeImageData: Data? { get }
  var awayImageData: Data? { get }
  var fetchWorkItem: DispatchWorkItem? { get }
  var updateWorkItem: DispatchWorkItem? { get }
  var teamNames: (home: String, away: String) { get }
  var scoreLabelText: String { get }
  init(matchResponse: MatchResponse)
  func fetchImages(completion: @escaping () -> Void)
  func prepareForReuse()
}

final class MatchCellViewModel: MatchCellViewModelProtocol {

  static let identifier = "matchCell"

  var matchResponse: MatchResponse

  var homeImageData: Data?
  var awayImageData: Data?

  var fetchWorkItem: DispatchWorkItem?
  var updateWorkItem: DispatchWorkItem?

  var teamNames: (home: String, away: String) {
    let teams = matchResponse.teams
    return (home: teams.home.name, away: teams.away.name)
  }

  var scoreLabelText: String {
    let goals = matchResponse.goals
    let homeTeamGoals = goals.home ?? 0
    let awayTeamGoals = goals.away ?? 0
    return "\(homeTeamGoals) : \(awayTeamGoals)"
  }

  init(matchResponse: MatchResponse) {
    self.matchResponse = matchResponse
  }

  func fetchImages(completion: @escaping () -> Void) {
    let teams = matchResponse.teams
    var homeData: Data?
    var awayData: Data?

    fetchWorkItem = DispatchWorkItem {
      let group = DispatchGroup()
      for i in 0..<2 {
        group.enter()
        defer { group.leave() }
        if i == 0 {
          homeData = ImageDataService.shared.imageData(urlString: teams.home.logo)
        } else {
          awayData = ImageDataService.shared.imageData(urlString: teams.away.logo)
        }
      }

      group.wait()
    }

    updateWorkItem = DispatchWorkItem { [weak self] in // TODO: возможно, не нужен. Проверить
      guard let self = self else { return }
      self.homeImageData = homeData
      self.awayImageData = awayData
      completion()
    }

    let queue = DispatchQueue(
      label: "com.andreev.soccer.group_of_two_images",
      attributes: .concurrent
    )

    precondition(fetchWorkItem != nil && updateWorkItem != nil)
    guard let fetchWorkItem = fetchWorkItem, let updateWorkItem = updateWorkItem else { return }

    fetchWorkItem.notify(queue: DispatchQueue.main, execute: updateWorkItem)
    queue.async(execute: fetchWorkItem)
  }

  func prepareForReuse() {
    fetchWorkItem?.cancel()
    updateWorkItem?.cancel()
  }

}

// MARK: - Private Methods
private extension MatchCellViewModel {
  func fetch(urlString: String?, completion: @escaping (Data?) -> Void) {
    ImageDataService.shared.asyncImageData(urlString: urlString) { data in
      completion(data)
    }
  }

}

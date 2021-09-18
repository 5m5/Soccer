//
//  MainViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

// MARK: - Protocol
protocol MainViewModelProtocol: AnyObject {
  var coordinator: MainCoordinator? { get }
  var title: String { get }

  var leaguesLabelTitle: String { get }
  var leaguesCount: Int { get }
  var leagueName: String { get }
  var matchesCount: Int { get }

  func fetchLeagues(completion: @escaping () -> Void)
  func collectionView(didSelectItemAt indexPath: IndexPath, completion: @escaping () -> Void)
  func tableView(didSelectRowAt indexPath: IndexPath)
  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol
  func matchCellViewModel(for indexPath: IndexPath) -> MatchCellViewModelProtocol
}

// MARK: - Implementation
final class MainViewModel: MainViewModelProtocol {

  // MARK: - Protocol Properties
  weak var coordinator: MainCoordinator?

  var title = "Matches history"
  var leaguesLabelTitle = "Select league"

  var leaguesCount = 0
  var leagueName = ""

  var matchesCount = 0

  // MARK: - Private Properties
  private var matches: [MatchResponse] = []
  private var leagues: [LeagueResponse] = []
  private var endPoint = EndPointFactory()

  func fetchLeagues(completion: @escaping () -> Void) {
    let parser = JSONParser<LeagueResult>()

    let urlBuilder = endPoint.leagues()
    let urlRequest = urlBuilder.urlRequest

    loadFromDataBase()
    completion()

    fetch(parser: parser, urlRequest: urlRequest) { [weak self] leagues in
      guard let self = self else { return }

      self.leagues = leagues.response
      self.leaguesCount = leagues.count
      completion()
    }
  }

  func collectionView(didSelectItemAt indexPath: IndexPath, completion: @escaping () -> Void) {
    let index = indexPath.row
    print(index, leaguesCount)
    if index >= leaguesCount { return }
    let leagueResponse = leagues[index]
    let league = leagueResponse.league
    let leagueId = league.id

    leagueName = league.name
    // Пока отображаем только последние сезоны лиг
    guard let season = leagueResponse.seasons.max(by: { $0.year < $1.year }) else { return }
    let seasonYear = season.year

    loadFromDataBase()

    let parser = JSONParser<MatchResult>()

    let urlBuilder = endPoint.matches()
    let urlRequest = urlBuilder
      .with(seasonYear: seasonYear)
      .with(leagueID: leagueId)
      .urlRequest

    fetch(parser: parser, urlRequest: urlRequest) { [weak self] matches in
      guard let self = self else { return }

      let sortedMatches = matches.response.sorted { $0.match.timestamp > $1.match.timestamp }
      CoreDataContainer.shared.saveMatches(response: sortedMatches)
      self.matches = sortedMatches
      self.matchesCount = matches.count
      completion()
    }
  }

  func tableView(didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row
    let matchResponse = matches[index]
    print(matchResponse.match.id)

    precondition(coordinator != nil, "Coordinator should not be nil")
    coordinator?.tableViewCellTapped(matchResponse: matchResponse)
  }

  func leagueCellViewModel(for indexPath: IndexPath) -> LeagueCellViewModelProtocol {
    let leagueResponse = leagues[indexPath.row]
    return LeagueCellViewModel(league: leagueResponse.league)
  }

  func matchCellViewModel(for indexPath: IndexPath) -> MatchCellViewModelProtocol {
    let matchResponse = matches[indexPath.row]
    return MatchCellViewModel(matchResponse: matchResponse)
  }

}

// MARK: - Private methods
private extension MainViewModel {
  func fetch<T: Codable>(
    parser: JSONParser<T>,
    urlRequest: URLRequest,
    completion: @escaping (T) -> Void
  ) {
    parser.fetch(urlRequest: urlRequest) { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async {
          completion(result)
        }
      case .failure(let error):
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.loadFromDataBase()
        }
        if error is NetworkError {
          print(error)
        } else {
          print(error.localizedDescription)
        }
      }
    }
  }

  func loadFromDataBase() {
    CoreDataContainer.shared.leagues { leagues in
      leagues.forEach { leagueObject in
        let league = League(
          id: Int(leagueObject.id),
          name: leagueObject.name,
          logo: leagueObject.logoPath
        )

        let leagueResponse = LeagueResponse(league: league, seasons: [Season(year: 2021)])
        let matchesObject = leagueObject.matches as! Set<MatchObject>

        matchesObject.forEach { matchObject in
          let match = Match(
            id: Int(matchObject.id),
            timestamp: matchObject.date.timeIntervalSince1970)

          let homeObject = matchObject.home
          let homeTeam = Team(
            id: Int(homeObject.id),
            name: homeObject.name,
            country: nil,
            logo: homeObject.logoPath
          )

          let awayObject = matchObject.away
          let awayTeam = Team(
            id: Int(awayObject.id),
            name: awayObject.name,
            country: nil,
            logo: awayObject.logoPath
          )

          let goals = Goals(home: Int(homeObject.goals), away: Int(awayObject.goals))

          let matchResponse = MatchResponse(
            match: match,
            league: league,
            teams: PlayingTeamResponse(home: homeTeam, away: awayTeam),
            goals: goals
          )

          self.matches.append(matchResponse)
          self.leagues.append(leagueResponse)
          print(matchResponse)
        }
      }
    }
  }

}

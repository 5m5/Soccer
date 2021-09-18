//
//  TeamDetailsViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//

import Foundation
import CoreLocation

// MARK: - Protocol
protocol TeamDetailsViewModelProtocol: AnyObject {
  var coordinator: TeamDetailsCoordinator? { get }
  var teamID: Int { get }
  var teamName: String { get }
  var teamLogoImageData: Data? { get }

  var title: String { get }
  var teamResponse: TeamResponse { get }

  var playersCount: Int { get }
  var players: [Player] { get }

  var stadiumLabelText: String { get }
  var placemark: CLPlacemark? { get }

  init(teamResponse: TeamResponse)

  func coordinates(completion: @escaping () -> Void)
  func fetchPlayers(completion: @escaping () -> Void)
  func playerCellViewModel(for indexPath: IndexPath) -> ImageCellViewModelProtocol
}

// MARK: - Implementation
final class TeamDetailsViewModel: TeamDetailsViewModelProtocol {

  var coordinator: TeamDetailsCoordinator?

  var teamID: Int { teamResponse.team.id }
  var teamName: String { teamResponse.team.name }
  var teamLogoImageData: Data?
  var title: String { teamResponse.team.name }

  var teamResponse: TeamResponse

  var playersCount: Int { players.count }
  var players: [Player] = []

  var stadiumLabelText: String {
    guard let name = teamResponse.stadium.name else { return "" }
    return "Stadium - \(name)"
  }

  var placemark: CLPlacemark?

  init(teamResponse: TeamResponse) {
    self.teamResponse = teamResponse
  }

  func coordinates(completion: @escaping () -> Void) {
    let geocoder = CLGeocoder()
    guard let city = teamResponse.stadium.city else { return }
    geocoder.geocodeAddressString(city) { [weak self] placemark, _ in
      guard let self = self else { return }
      self.placemark = placemark?.first
      completion()
    }
  }

  func fetchPlayers(completion: @escaping () -> Void) {
    let parser = JSONParser<PlayerResult>()
    let urlRequest = EndPointFactory().players().with(teamID: teamResponse.team.id).urlRequest

    parser.fetch(urlRequest: urlRequest) { result in
      switch result {
      case .success(let result):
        DispatchQueue.main.async { [weak self] in
          guard
            let self = self,
            let playerResponse = result.response.first else { return }
          let players = playerResponse.players
          self.players = players
          self.teamResponse.players = players
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

  func playerCellViewModel(for indexPath: IndexPath) -> ImageCellViewModelProtocol {
    let player = players[indexPath.row]
    return ImageCellViewModel(imagePath: player.photo)
  }

}

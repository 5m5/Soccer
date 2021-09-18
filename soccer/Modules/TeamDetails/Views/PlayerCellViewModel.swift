//
//  PlayerCellViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//

import Foundation

protocol PlayerCellViewModelProtocol: AnyObject {
  var player: Player { get }
  var imageData: Data? { get }
  init(player: Player)
}

final class PlayerCellViewModel: PlayerCellViewModelProtocol {
  static let identifier = "playerCell"

  var player: Player
  var imageData: Data? { ImageDataService.shared.imageData(urlString: player.photo) }

  init(player: Player) {
    self.player = player
  }

}


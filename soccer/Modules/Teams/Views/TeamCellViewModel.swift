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

  var fetchWorkItem: DispatchWorkItem? { get }
  var updateWorkItem: DispatchWorkItem? { get }

  init(team: Team)

  func prepareForReuse()
  func fetchImage(completion: @escaping () -> Void)
}

final class TeamCellViewModel: TeamCellViewModelProtocol {
  static let identifier = "teamCell"

  var team: Team
  var teamName: String { team.name }
  var countryName: String { team.country ?? "" }
  var imageData: Data?

  var fetchWorkItem: DispatchWorkItem?
  var updateWorkItem: DispatchWorkItem?

  init(team: Team) {
    self.team = team
  }

  func prepareForReuse() {
    fetchWorkItem?.cancel()
    updateWorkItem?.cancel()
  }

  func fetchImage(completion: @escaping () -> Void) {
    var fetchedImageData: Data?

    fetchWorkItem = DispatchWorkItem {  [weak self] in
      guard let self = self else { return }
      fetchedImageData = ImageDataService.shared.imageData(urlString: self.team.logo)
    }

    updateWorkItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.imageData = fetchedImageData
      completion()
    }

    let queue = DispatchQueue(label: "com.andreev.soccer.image_load", attributes: .concurrent)
    precondition(fetchWorkItem != nil && updateWorkItem != nil)
    guard let fetchWorkItem = fetchWorkItem, let updateWorkItem = updateWorkItem else { return }

    fetchWorkItem.notify(queue: DispatchQueue.main, execute: updateWorkItem)
    queue.async(execute: fetchWorkItem)
  }

}

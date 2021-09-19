//
//  ImageCellViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import Foundation

protocol ImageCellViewModelProtocol: AnyObject {
  var imagePath: String? { get }
  var imageData: Data? { get }
  var fetchWorkItem: DispatchWorkItem? { get }
  var updateWorkItem: DispatchWorkItem? { get }

  init(imagePath: String?)

  func prepareForReuse()
  func fetchImage(completion: @escaping () -> Void)
}

final class ImageCellViewModel: ImageCellViewModelProtocol {

  static let identifier = "imageCell"

  var imagePath: String?
  var imageData: Data?

  var fetchWorkItem: DispatchWorkItem?
  var updateWorkItem: DispatchWorkItem?

  init(imagePath: String?) {
    self.imagePath = imagePath
  }

  func prepareForReuse() {
    fetchWorkItem?.cancel()
    updateWorkItem?.cancel()
  }

  func fetchImage(completion: @escaping () -> Void) {
    var fetchedImageData: Data?

    fetchWorkItem = DispatchWorkItem {  [weak self] in
      guard let self = self else { return }
      fetchedImageData = ImageDataService.shared.imageData(urlString: self.imagePath)
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

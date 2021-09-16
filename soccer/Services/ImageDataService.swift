//
//  ImageDataService.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import Foundation

final class ImageDataService {
  static let shared = ImageDataService()

  private init() { }

  func imageData(urlString: String?) -> Data? {

    guard
      let urlString = urlString,
      let url = URL(string: urlString) else { return nil }

    let data = try? Data(contentsOf: url)

    return data
  }

  func asyncImageData(urlString: String?, completion: @escaping (Data?) -> Void) {
    let queue = DispatchQueue(label: "com.andreev.soccer.image_load", attributes: .concurrent)
    queue.async {
      guard
        let urlString = urlString,
        let url = URL(string: urlString) else { return }

      let data = try? Data(contentsOf: url)
      completion(data)
    }

  }

}

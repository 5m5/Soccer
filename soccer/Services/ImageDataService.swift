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

  func imageDataFrom(url: URL?) -> Data? {
    var data: Data?

    //DispatchQueue.global().async {
      guard let url = url else { return nil }
      data = try? Data(contentsOf: url)
    //}

    return data
  }

}

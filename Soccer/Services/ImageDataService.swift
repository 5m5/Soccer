//
//  ImageDataService.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import Foundation

final class ImageDataService {
  static let shared = ImageDataService()

  private let cache = NSCache<AnyObject, AnyObject>()

  private init() { }

  func imageData(urlString: String?) -> Data? {

    guard
      let urlString = urlString,
      let url = URL(string: urlString) else { return nil }

    if let cachedData = cache.object(forKey: url as AnyObject) as? Data {
      return cachedData
    }

    let data = try? Data(contentsOf: url)

    cache.setObject(data as AnyObject, forKey: url as AnyObject)

    return data
  }

}

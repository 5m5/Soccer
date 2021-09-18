//
//  JSONParser.swift
//  soccer
//
//  Created by Mikhail Andreev on 02.09.2021.
//

import Foundation

enum NetworkError: Error {
  case invalidResponse
  case invalidData
  case decodingError
  case serverError
}

final class JSONParser<T: Codable> {
  typealias ResultCompletion<T> = (Result<T, Error>) -> Void

  func fetch(urlRequest: URLRequest, completion: @escaping ResultCompletion<T>) {
    #if DEBUG
    print(urlRequest)
    #endif

    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 5
    configuration.timeoutIntervalForResource = 10
    let session = URLSession(configuration: configuration)
    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        completion(.failure(error))
      }

      guard let response = response as? HTTPURLResponse else {
        completion(.failure(NetworkError.invalidResponse))
        return
      }

      if 200...299 ~= response.statusCode {
        if let data = data {
          do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
          } catch {
            completion(.failure(NetworkError.decodingError))
          }
        } else {
          completion(.failure(NetworkError.invalidData))
        }
      } else {
        completion(.failure(NetworkError.serverError))
      }
    }

    dataTask.resume()
  }

}

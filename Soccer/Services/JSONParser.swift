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

protocol JSONParsing: AnyObject {
  associatedtype Model: Codable
  typealias ResultCompletion<Model> = (Result<Model, Error>) -> Void
  func fetch(urlRequest: URLRequest, completion: @escaping ResultCompletion<Model>)
}

class JSONParser<T: Codable>: JSONParsing {
  func fetch(urlRequest: URLRequest, completion: @escaping ResultCompletion<T>) {

    let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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

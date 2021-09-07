//
//  MatchCellViewModel.swift
//  soccer
//
//  Created by Mikhail Andreev on 04.09.2021.
//

import Foundation

protocol MatchCellViewModelProtocol: AnyObject {
  var matchResponse: MatchResponse { get }
  init(matchResponse: MatchResponse)
}

final class MatchCellViewModel: MatchCellViewModelProtocol {
  static let identifier = "matchCell"

  var matchResponse: MatchResponse

  init(matchResponse: MatchResponse) {
    self.matchResponse = matchResponse
  }

}

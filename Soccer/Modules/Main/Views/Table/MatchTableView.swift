//
//  LeagueTableView.swift
//  soccer
//
//  Created by Mikhail Andreev on 04.09.2021.
//

import UIKit

final class MatchTableView: UITableView {

  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)

    rowHeight = 90
    separatorStyle = .none
    showsVerticalScrollIndicator = false
    translatesAutoresizingMaskIntoConstraints = false
    register(MatchTableViewCell.self, forCellReuseIdentifier: MatchCellViewModel.identifier)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}

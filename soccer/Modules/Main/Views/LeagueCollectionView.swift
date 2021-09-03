//
//  LeagueCollectionView.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import UIKit

class LeagueCollectionView: UICollectionView {

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal

    super.init(frame: .zero, collectionViewLayout: layout)

    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground

    register(
      LeagueCollectionViewCell.self,
      forCellWithReuseIdentifier: LeagueCellViewModel.identifier
    )
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}
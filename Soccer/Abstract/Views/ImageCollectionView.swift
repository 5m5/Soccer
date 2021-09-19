//
//  ImageCollectionView.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import UIKit

final class ImageCollectionView: UICollectionView {

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 16

    super.init(frame: .zero, collectionViewLayout: layout)

    showsHorizontalScrollIndicator = false

    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground

    register(
      ImageCollectionViewCell.self,
      forCellWithReuseIdentifier: ImageCellViewModel.identifier
    )
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}

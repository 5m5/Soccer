//
//  LeagueCollectionViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import UIKit

class LeagueCollectionViewCell: UICollectionViewCell {

  var viewModel: LeagueCellViewModelProtocol!

  private lazy var imageView: UIImageView = {
    // TODO: Временно системное изображение
    let image = UIImage(systemName: "pencil")
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(imageView)

    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}

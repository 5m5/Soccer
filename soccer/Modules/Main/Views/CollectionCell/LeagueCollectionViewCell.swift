//
//  LeagueCollectionViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import UIKit

class LeagueCollectionViewCell: UICollectionViewCell {

  var viewModel: LeagueCellViewModelProtocol? {
    didSet {
      guard let viewModel = viewModel else { preconditionFailure("Can't unwrap viewModel") }
      DispatchQueue.global().async {
        if let imageData = viewModel.imageData {
          DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.image = UIImage(data: imageData)
          }
        }
      }
    }
  }

  private lazy var imageView: UIImageView = {
    // TODO: Временно системное изображение
    let image = UIImage(systemName: "pencil")
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 10
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.systemGray.cgColor
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(imageView)

    let constant: CGFloat = 5
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor,
        constant: constant
      ),
      imageView.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -constant
      ),
      imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: constant),
      imageView.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor,
        constant: -constant
      ),
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }

}

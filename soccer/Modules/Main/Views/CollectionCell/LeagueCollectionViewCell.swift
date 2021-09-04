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
        guard
          let urlString = viewModel.league.logo,
          let url = URL(string: urlString),
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data) else { return }

        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }

          self.imageView.image = image
        }
      }
    }
  }

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(imageView)

    layer.cornerRadius = 10
    layer.borderWidth = 2
    layer.borderColor = UIColor.systemGray.cgColor

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

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

}

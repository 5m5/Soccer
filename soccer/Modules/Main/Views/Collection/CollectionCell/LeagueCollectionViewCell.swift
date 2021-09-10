//
//  LeagueCollectionViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import UIKit

class LeagueCollectionViewCell: UICollectionViewCell {

  var viewModel: LeagueCellViewModelProtocol? {
    didSet { asyncLoadImage() }
  }

  // MARK: - Private Properties
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  // MARK: - Lifecycle
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

  override func layoutSubviews() {
    super.layoutSubviews()

    layer.cornerRadius = 10
    layer.borderWidth = 2
    layer.borderColor = UIColor.systemGray.cgColor
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  override var isSelected: Bool {
    willSet {
      layer.borderColor = (newValue ? UIColor.systemBlue : UIColor.systemGray).cgColor
    }
  }

  // MARK: - Private Methods
  private func asyncLoadImage() {
    guard let viewModel = viewModel else { preconditionFailure("Can't unwrap viewModel") }

    DispatchQueue.global().async {
      var image = UIImage(named: "football_player")

      if let data = viewModel.imageData, let leagueLogoImage = UIImage(data: data) {
        image = leagueLogoImage
      }

      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.imageView.image = image
      }
    }
  }

}

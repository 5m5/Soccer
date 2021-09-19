//
//  ImageCollectionViewCell.swift
//  soccer
//
//  Created by Mikhail Andreev on 03.09.2021.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

  var viewModel: ImageCellViewModelProtocol? {
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
    layer.borderColor = (isSelected ? UIColor.systemBlue : UIColor.systemGray).cgColor
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    viewModel?.prepareForReuse()
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

    let defaultImage = UIImage(named: "football_player")

    viewModel.fetchImage {
      self.imageView.image = defaultImage

      if let data = viewModel.imageData, let image = UIImage(data: data) {
        self.imageView.image = image
      }
    }
  }

}

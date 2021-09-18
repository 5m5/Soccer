//
//  TeamDetailsViewController.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//

import UIKit
import MapKit

class TeamDetailsViewController: ViewModelController<TeamDetailsViewModelProtocol> {

  private lazy var playersLabel = makeLabel()
  private lazy var collectionView = ImageCollectionView()
  private lazy var stadiumLabel = makeLabel()
  private lazy var mapView = makeMapView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
  }

}

private extension TeamDetailsViewController {
  func setupView() {
    view.backgroundColor = .systemBackground
    title = viewModel.title

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.allowsSelection = false

    playersLabel.text = "Squad"
    stadiumLabel.font = stadiumLabel.font.withSize(18)
    stadiumLabel.text = viewModel.stadiumLabelText

    viewModel.fetchPlayers { [weak self] in
      guard let self = self else { return }
      self.collectionView.reloadData()
    }

    viewModel.coordinates { [weak self] in
      guard let self = self else { return }
      let annotation = MKPointAnnotation()
      guard let coordinate = self.viewModel.placemark?.location?.coordinate else { return }
      annotation.coordinate = coordinate
      self.mapView.addAnnotation(annotation)
      self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }

    view.addSubview(playersLabel)
    view.addSubview(collectionView)
    view.addSubview(stadiumLabel)
    view.addSubview(mapView)

    setupConstraints()
  }

  func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    let margin: CGFloat = 16

    NSLayoutConstraint.activate([
      playersLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
      playersLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: margin),
      playersLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),

      collectionView.topAnchor.constraint(equalTo: playersLabel.bottomAnchor, constant: margin),
      collectionView.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor),
      collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1 / 3),

      stadiumLabel.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor),
      stadiumLabel.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor),
      stadiumLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: margin),

      mapView.topAnchor.constraint(equalTo: stadiumLabel.bottomAnchor, constant: margin),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin),
    ])
  }

  func makeLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont(name: "Legacy", size: 28)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  func makeMapView() -> MKMapView {
    let mapView = MKMapView()
    mapView.translatesAutoresizingMaskIntoConstraints = false
    return mapView
  }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension TeamDetailsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let insets = collectionView.contentInset
    let height = collectionView.bounds.height - insets.top - insets.bottom - 1
    return CGSize(width: collectionView.bounds.width / 3, height: height)
  }

}

// MARK: - UICollectionViewDataSource
extension TeamDetailsViewController: UICollectionViewDataSource {

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let identifier = ImageCellViewModel.identifier
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: identifier,
      for: indexPath
    ) as? ImageCollectionViewCell else { preconditionFailure("Can't cast cell") }

    cell.viewModel = viewModel.playerCellViewModel(for: indexPath)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    viewModel.playersCount
  }

}

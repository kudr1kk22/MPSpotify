//
//  NewReleaseCollectionViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 29.01.23.
//

import UIKit

final class NewReleaseCollectionViewCell: UICollectionViewCell {

  //MARK: - IBOutlets

  @IBOutlet private weak var artistLabel: UILabel!
  @IBOutlet private weak var songnameLabel: UILabel!
  @IBOutlet private weak var albumImage: UIImageView!

  //MARK: - Configure cell

  func configure(with viewModel: NewReleasesCellViewModel) {
    songnameLabel.text = viewModel.trackName
    artistLabel.text = viewModel.artistName
    if let imageURL = viewModel.artistURL {
      albumImage.sd_setImage(with: imageURL)
    }
  }
}

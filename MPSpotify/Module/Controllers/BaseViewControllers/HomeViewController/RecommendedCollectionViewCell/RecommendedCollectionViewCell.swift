//
//  RecommendedCollectionViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import UIKit

final class RecommendedCollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var songName: UILabel!
  @IBOutlet private weak var artistName: UILabel!

  func configure(with viewModel: RecommendedCollectionViewCellViewModel) {
    songName.text = viewModel.name
    artistName.text = viewModel.artistName
    if let imageURL = viewModel.imageURL {
      imageView.sd_setImage(with: imageURL)
    }
  }

}

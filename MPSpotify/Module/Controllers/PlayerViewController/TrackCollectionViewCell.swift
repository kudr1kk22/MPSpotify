//
//  TrackCollectionViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 13.02.23.
//

import UIKit

final class TrackCollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var imageView: UIImageView!

  func configure(with viewModel: URL) {

    if let imageURL = URL(string: viewModel.absoluteString) {
      DispatchQueue.main.async {
        if let imageData = try? Data(contentsOf: imageURL) {
          self.imageView.image = UIImage(data: imageData)
        }
      }
    }
  }

}

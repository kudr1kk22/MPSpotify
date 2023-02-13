//
//  PlaylistTableViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import UIKit

final class PlaylistTableViewCell: UITableViewCell {

  //MARK: - IBOutlets

  @IBOutlet private weak var artistImage: UIImageView!
  @IBOutlet private weak var songNameLabel: UILabel!
  @IBOutlet private weak var artistNameLabel: UILabel!



  func configure(with viewModel: PlaylistTableViewCellVM) {
    songNameLabel.text = viewModel.name
    artistNameLabel.text = viewModel.artistName
    if let imageURL = URL(string: viewModel.imageURL?.absoluteString ?? "") {
      DispatchQueue.global().async {
        if let imageData = try? Data(contentsOf: imageURL) {
          DispatchQueue.main.async {
            self.artistImage.image = UIImage(data: imageData)
          }
        }
      }
    }
  }
}

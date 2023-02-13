//
//  DetailsRealeasTableViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 7.02.23.
//

import UIKit

final class DetailsRealeasTableViewCell: UITableViewCell {

  //MARK: - IBOutlets

  @IBOutlet private weak var artistLabel: UILabel!
  @IBOutlet private weak var songnameLabel: UILabel!

  //MARK: - Properties


  //MARK: - Configure cell

  func configure(with viewModel: DetailsReleasTVCViewModel) {
    songnameLabel.text = viewModel.songName
    artistLabel.text = viewModel.artistName
  }
  
}

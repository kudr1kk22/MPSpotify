//
//  SearchResultsTableViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 15.02.23.
//

import UIKit

final class SearchResultsTableViewCell: UITableViewCell {

  @IBOutlet private weak var songLabel: UILabel!
  @IBOutlet private weak var artistImage: UIImageView!
  @IBOutlet private weak var subtitleLabel: UILabel!

  func configure(with viewModel: SearchResultTableViewModel) {
    songLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    artistImage.sd_setImage(with: viewModel.imageURL, completed: nil)
  }

}

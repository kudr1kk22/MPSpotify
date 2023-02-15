//
//  PlaylistVCHeaderView.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import UIKit

protocol PlaylistHeaderViewPlayButtonTapDelegate: AnyObject {
  func playAlltracks(_ header: PlaylistVCHeaderView)
}

final class PlaylistVCHeaderView: UITableViewHeaderFooterView {

//MARK: - IBOutlets

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var playlistNameLabel: UILabel!
  @IBOutlet private weak var playlistTextLabel: UILabel!
  @IBOutlet private weak var ownerLabel: UILabel!

  //MARK: - Properties

  weak var playlistVCheaderViewDelegate: PlaylistHeaderViewPlayButtonTapDelegate?

  //MARK: - Play Button

  @IBAction private func playButtonDidTap() {
    playlistVCheaderViewDelegate?.playAlltracks(self)
  }

  //MARK: - Configure cell

  func configure(with viewModel: PlaylistVCHeaderViewVM) {
    playlistNameLabel.text = viewModel.name
    playlistTextLabel.text = viewModel.description
    ownerLabel.text = viewModel.ownerName

    if let imageURL = URL(string: viewModel.imageURL?.absoluteString ?? "") {
      imageView.sd_setImage(with: imageURL)
    }
  }
}








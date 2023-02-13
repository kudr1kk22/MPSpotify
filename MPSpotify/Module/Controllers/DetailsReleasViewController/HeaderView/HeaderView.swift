//
//  HeaderView.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 7.02.23.
//

import UIKit

protocol HeaderViewPlayButtonTapDelegate: AnyObject {
  func playAlltracks(_ header: HeaderView)
}

final class HeaderView: UITableViewHeaderFooterView {

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var releaseDate: UILabel!
  @IBOutlet private weak var artistName: UILabel!
  @IBOutlet private weak var songName: UILabel!

  weak var headerViewDelegate: HeaderViewPlayButtonTapDelegate?


  //MARK: - Play Button

  @IBAction private func playButtonDidTap() {
    headerViewDelegate?.playAlltracks(self)
  }


  //MARK: - Configure cell

  func configure(with viewModel: HeaderViewVM) {
    songName.text = viewModel.songName
    artistName.text = viewModel.artistName
    if let date = viewModel.releaseDate {
      releaseDate.text = "Release date: \(date)"
    }
    if let imageURL = URL(string: viewModel.image?.absoluteString ?? "") {
      if let imageData = try? Data(contentsOf: imageURL) {
        DispatchQueue.main.async {
          self.imageView.image = UIImage(data: imageData)
        }
      }
    }
  }

}


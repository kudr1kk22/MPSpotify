//
//  CategoryInfoCollectionViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 11.02.23.
//

import UIKit

final class CategoryInfoCollectionViewCell: UICollectionViewCell {

  @IBOutlet  weak var imageView: UIImageView!
  @IBOutlet private weak var name: UILabel!
  @IBOutlet private weak var creatorName: UILabel!



  override func prepareForReuse() {
       super.prepareForReuse()
       self.imageView.image = UIImage(systemName: "music.note.tv")
   }

  // MARK: - Image Loading


  func configure(with viewModel: CategoryInfoCollectionViewCellViewModel) {
    creatorName.text = viewModel.creatorName
    name.text = viewModel.name
    if let imageURL = URL(string: viewModel.imageURL?.absoluteString ?? "") {
      DispatchQueue.global().async {
        if let imageData = try? Data(contentsOf: imageURL) {
          DispatchQueue.main.async {
            self.imageView.image = UIImage(data: imageData)
          }
        }
      }
    }

  }

}

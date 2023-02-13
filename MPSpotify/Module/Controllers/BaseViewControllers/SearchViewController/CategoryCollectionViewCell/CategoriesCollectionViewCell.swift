//
//  CategoriesCollectionViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 11.02.23.
//

import UIKit

final class CategoriesCollectionViewCell: UICollectionViewCell {

  //MARK: - IBOutlets

  @IBOutlet private weak var categoryImageView: UIImageView!
  @IBOutlet private weak var categoryName: UILabel!

  func configure(with viewModel: CategoriesCellViewModel) {
    categoryName.text = viewModel.title
    if let imageURL = viewModel.imageURL {
      DispatchQueue.global().async {
        if let imageData = try? Data(contentsOf: imageURL) {
          DispatchQueue.main.async {
            self.categoryImageView.image = UIImage(data: imageData)
          }
        }
      }
    }
  }

}

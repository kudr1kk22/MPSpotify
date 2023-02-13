//
//  HeaderTitleViewCell.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import UIKit

final class HeaderTitleViewCell: UICollectionReusableView {

  @IBOutlet private weak var headerTitle: UILabel!

  func configure(with title: String) {
    headerTitle.text = title
  }

}

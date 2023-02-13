//
//  UIImageView+Rounded.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 1.02.23.
//

import UIKit

extension UIImageView {

    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

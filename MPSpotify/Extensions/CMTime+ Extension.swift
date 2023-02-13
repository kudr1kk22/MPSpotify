//
//  CMTime+ Extension.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 9.02.23.
//

import Foundation
import AVKit

extension CMTime {

    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatedString = String(format: "%02d:%02d", minutes,seconds)
        return timeFormatedString
    }
}

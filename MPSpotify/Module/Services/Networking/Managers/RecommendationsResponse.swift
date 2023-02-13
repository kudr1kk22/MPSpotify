//
//  RecommendationsResponse.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}

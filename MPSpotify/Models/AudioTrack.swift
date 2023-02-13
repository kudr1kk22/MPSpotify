//
//  AudioTrack.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 3.02.23.
//

import Foundation

struct AudioTrack: Codable {
    var album: AlbumModel?
    let artists: [ArtistModel]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalURLs: [String: String]
    let id: String
    let name: String
    let previewURL: String?

  enum CodingKeys: String, CodingKey {
    case album
    case artists
    case availableMarkets = "available_markets"
    case discNumber = "disc_number"
    case durationMs = "duration_ms"
    case explicit
    case externalURLs = "external_urls"
    case id
    case name
    case previewURL = "preview_url"
  }
}

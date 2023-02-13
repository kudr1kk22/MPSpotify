//
//  AlbumDetails.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 8.02.23.
//

import Foundation

struct AlbumDetails: Codable {
    let albumType: String
    let artists: [ArtistModel]
    let availableMarkets: [String]
    let externalURLs: [String: String]
    let id: String
    let images: [ImagesResponse]
    let label: String
    let name: String
    let tracks: Tracks

  enum CodingKeys: String, CodingKey {
    case albumType = "album_type"
    case artists
    case availableMarkets = "available_markets"
    case externalURLs = "external_urls"
    case id
    case images
    case label
    case name
    case tracks
  }
}

struct Tracks: Codable {
    let items: [AudioTrack]
}

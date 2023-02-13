//
//  NewReleases.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 2.02.23.
//

import Foundation

struct NewReleases: Codable {
    let albums: AlbumsModel
}

struct AlbumsModel: Codable {
    let items: [AlbumModel]
}

struct AlbumModel: Codable {
    let albumType: String
    let availableMarkets: [String]
    let id: String
    let images: [ImagesResponse]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let artists: [ArtistModel]

  enum CodingKeys: String, CodingKey {
    case albumType = "album_type"
    case availableMarkets = "available_markets"
    case id
    case images
    case name
    case releaseDate = "release_date"
    case totalTracks = "total_tracks"
    case artists
  }
}

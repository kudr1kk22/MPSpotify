//
//  PlaylistDetailsResponse.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let externalURLs: [String: String]
    let id: String
    let images: [ImagesResponse]
    let name: String
    let tracks: PlaylistTracksResponse

  enum CodingKeys: String, CodingKey {
    case description
    case externalURLs = "external_urls"
    case id
    case images
    case name
    case tracks
  }
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}

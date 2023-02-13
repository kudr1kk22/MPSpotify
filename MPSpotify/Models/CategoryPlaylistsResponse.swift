//
//  CategoryPlaylistsResponse.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 11.02.23.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let displayName: String
    let externalURLs: [String: String]
    let id: String

  enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case externalURLs = "external_urls"
    case id
  }
}

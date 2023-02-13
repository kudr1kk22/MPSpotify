//
//  Playlist.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 8.02.23.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let externalURLs: [String: String]
    let id: String
    let images: [ImagesResponse]
    let name: String
    let owner: User

  enum CodingKeys: String, CodingKey {
    case description
    case externalURLs = "external_urls"
    case id
    case images
    case name
    case owner
  }
}


//
//  ArtistModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 2.02.23.
//

import Foundation

struct ArtistModel: Codable {
  let externalURLs: [String: String]
  let id: String
  let name: String
  let type: String
  let images: [ImagesResponse]?

  enum CodingKeys: String, CodingKey {
    case externalURLs = "external_urls"
    case id
    case name
    case type
    case images
  }
}


//
//  UserProfile.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 29.01.23.
//

import Foundation

struct UserProfile: Codable {
  let country: String
  let displayName: String
  let email: String
  let explicitContent: [String: Bool]
  let externalUrls: [String: String]
  let id: String
  let followers: Followers
  let product: String
  let images: [UserImage]

  enum CodingKeys: String, CodingKey {
    case country
    case displayName = "display_name"
    case email
    case explicitContent = "explicit_content"
    case externalUrls = "external_urls"
    case id
    case followers
    case product
    case images
  }
}

struct UserImage: Codable {
  let url: String
}

struct Followers: Codable {
  let total: Int
}



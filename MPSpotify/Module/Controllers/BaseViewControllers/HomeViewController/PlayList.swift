//
//  PlayList.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 3.02.23.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [ImagesResponse]
    let name: String
//    let owner: User
}

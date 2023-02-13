//
//  AllCategories.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 11.02.23.
//

import Foundation

struct AllCategories: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [ImagesResponse]
}

//
//  SearchResultsResponse.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 15.02.23.
//

import Foundation

struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTrackssResponse
}

struct SearchAlbumResponse: Codable {
    let items: [AlbumModel]
}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
}

struct SearchTrackssResponse: Codable {
    let items: [AudioTrack]
}

//
//  SearchResult.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 15.02.23.
//

import Foundation

enum SearchResult {
    case album(model: AlbumModel)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}

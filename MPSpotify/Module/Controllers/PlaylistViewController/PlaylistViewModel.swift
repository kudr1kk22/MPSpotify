//
//  PlaylistViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import Foundation

protocol PlaylistViewModelProtocol {
  var playlist: Playlist { get }
  var viewModels: [PlaylistTableViewCellVM] { get set }
  var tracks: [AudioTrack] { get set }
  var complitionHandler: (() -> Void)? { get set }
}

final class PlaylistViewModel: PlaylistViewModelProtocol {


  //MARK: - Properties

  var playlist: Playlist
  var viewModels: [PlaylistTableViewCellVM] = []
  var apiCaller: APICallerProtocol
  var tracks: [AudioTrack] = []
  var complitionHandler: (() -> Void)?


  //MARK: - Initialization

  init(playlist: Playlist, apiCaller: APICallerProtocol) {
      self.playlist = playlist
      self.apiCaller = apiCaller
      fetchData()
  }


  //MARK: - Get Playlist Details

  func fetchData() {
    apiCaller.getPlaylistDetails(for: playlist) { result in
      switch result {
      case .success(let model):
        self.tracks = model.tracks.items.compactMap({ $0.track })
        self.viewModels = model.tracks.items.compactMap({ PlaylistTableViewCellVM(
            name: $0.track.name,
            artistName: $0.track.artists.first?.name ?? "-",
            imageURL: URL(string: $0.track.album?.images.first?.url ?? ""))
        })
        DispatchQueue.main.async {
          self.complitionHandler?()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
}

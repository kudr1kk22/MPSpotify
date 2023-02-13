//
//  DetailsReleasViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 8.02.23.
//

import Foundation

protocol DetailsReleasVMProtocol {
  var album: AlbumModel { get set }
  var viewModels: [DetailsReleasTVCViewModel] { get }
  var complitionHandler: (() -> Void)? { get set }
  var tracks: [AudioTrack] { get }

  func fetchData()
}

final class DetailsReleasViewModel {
  var album: AlbumModel

  private var apiCaller: APICallerProtocol
  var tracks = [AudioTrack]()
  var viewModels = [DetailsReleasTVCViewModel]()
  var complitionHandler: (() -> Void)?


  init(album: AlbumModel, apiCaller: APICallerProtocol) {
    self.album = album
    self.apiCaller = apiCaller
    fetchData()
  }


}

extension DetailsReleasViewModel: DetailsReleasVMProtocol {

  func fetchData() {
    apiCaller.getAlbumDetails(for: album) { [weak self] result in
          DispatchQueue.main.async {
              switch result {
              case .success(let model):
                  self?.tracks = model.tracks.items
                self?.viewModels = model.tracks.items.compactMap({
                      DetailsReleasTVCViewModel(
                        artistName: $0.artists.first?.name ?? "-",
                        songName: $0.name
                      )
                  })
                self?.complitionHandler?()
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
      }
  }
}

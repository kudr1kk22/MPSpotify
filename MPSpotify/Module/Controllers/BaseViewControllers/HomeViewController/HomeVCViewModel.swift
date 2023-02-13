//
//  HomeVCViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 2.02.23.
//

import Foundation

enum SectionType {
  case newReleases(viewModels: [NewReleasesCellViewModel])
  case recommendedTracks(viewModels: [RecommendedCollectionViewCellViewModel])

  var title: String {
    switch self {
    case .newReleases:
      return "New Released Albums"
    case .recommendedTracks:
      return "Recommended"
    }
  }
}

protocol HomeVCViewModelProtocol {
  var newReleasesModel: NewReleases? { get }
  var recommendationsModel: RecommendationsResponse? { get }

  var complitionHandler: (() -> Void)? { get set }
  var sections: [SectionType] { get }
  var newAlbums: [AlbumModel] { get set }

  var apiCaller: APICallerProtocol { get }

  func fetchNewReleases()
  func configureModels(newAlbums: [AlbumModel], tracks: [AudioTrack])
}

final class HomeVCViewModel {

  let apiCaller: APICallerProtocol
  var newReleasesModel: NewReleases?
  var recommendationsModel: RecommendationsResponse?
  var complitionHandler: (() -> Void)?

  var newAlbums: [AlbumModel] = []
  private var playlists: [Playlist] = []
  private var tracks: [AudioTrack] = []
  var sections = [SectionType]()

  init(apiCaller: APICallerProtocol) {
    self.apiCaller = apiCaller
    fetchNewReleases()
    fetchRecommendations()
  }

}

extension HomeVCViewModel: HomeVCViewModelProtocol {

  //MARK: - Configure models
  
  func configureModels(newAlbums: [AlbumModel], tracks: [AudioTrack]) {
    self.newAlbums = newAlbums
    self.tracks = tracks

    sections.append(.newReleases(viewModels: newAlbums.compactMap({
      return NewReleasesCellViewModel(
        trackName: $0.name,
        artistURL: URL(string: $0.images.first?.url ?? ""),
        artistName: $0.artists.first?.name ?? "-"
      )
    })))
    let filterRecommendedTracks = tracks.filter { $0.previewURL != nil }
    sections.append(.recommendedTracks(viewModels: filterRecommendedTracks.compactMap({
      return RecommendedCollectionViewCellViewModel(
        name: $0.name,
        artistName: $0.artists.first?.name ?? "-",
        imageURL: URL(string: $0.album?.images.first?.url ?? "")
      )
    })))
  }



  //MARK: - Fetch new releases

  func fetchNewReleases() {
    apiCaller.getNewReleases { [weak self] result in
      switch result {
      case .success(let model):
        self?.newReleasesModel = model
      case .failure(let error):
        print("Error fetchUserProfile: \(error.localizedDescription)")
      }
    }
  }

  //MARK: - Fetch recommendations

  func fetchRecommendations() {
    apiCaller.gerRecommendedGenres { [weak self] result in
      switch result {
      case .success(let model):
        let genres = model.genres
        var seeds = Set<String>()
        while seeds.count < 5 {
          if let random = genres.randomElement() {
            seeds.insert(random)
          }
        }

        self?.apiCaller.getRecommendations(genres: seeds) { recommendedResult in

          switch recommendedResult {
          case .success(let model):
            self?.recommendationsModel = model
            DispatchQueue.main.async {
              self?.complitionHandler?()
            }
          case .failure(let error):
            print(error.localizedDescription)
          }
        }
      case .failure(let error):
        print("Error fetchUserProfile: \(error.localizedDescription)")
      }
    }
  }
}

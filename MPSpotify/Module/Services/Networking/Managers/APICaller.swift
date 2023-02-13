//
//  APICaller.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 29.01.23.
//

import Foundation

protocol APICallerProtocol {
  func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
//  func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void)
  func getNewReleases(completion: @escaping (Result<NewReleases, Error>) -> Void)
  func getCategories(completion: @escaping (Result<[Category], Error>) -> Void)
  func getAlbumDetails(for album: AlbumModel, completion: @escaping (Result<AlbumDetails, Error>) -> Void)
  func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void)
  func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void)
  func gerRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void))
  func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void))
}

private enum APIError: Error {
    case failedToGetData
}

private enum Constants {
static let baseAPIURL = "https://api.spotify.com/v1"
}

final class APICaller: APICallerProtocol {

  private let authManager: AuthManagerProtocol

  init(authManager: AuthManager) {
    self.authManager = authManager
  }


  //MARK: - Get Current User Profile
  func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
    authManager.withValidToken { token in
      self.createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { request in
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
          guard let data = data, error == nil else { return }
          do {
            let result = try JSONDecoder().decode(UserProfile.self, from: data)
            completion(.success(result))
          }
          catch {
            completion(.failure(error))
          }
        }
        task.resume()
      }
    }
  }

//MARK: - Get User Playlists

//  func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void) {
//    authManager.withValidToken { token in
//      self.createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists"), type: .GET) { request in
//        let task = URLSession.shared.dataTask(with: request) { data, _, error in
//          guard let data = data, error == nil else { return }
//          do {
//            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//
//          }
//          catch {
//            completion(.failure(error))
//          }
//        }
//        task.resume()
//      }
//    }
//  }

//MARK: - Get Several Browse Categories

  func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
    authManager.withValidToken { token in
      self.createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"), type: .GET) { request in
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
          guard let data = data, error == nil else { return }
          do {
            let result = try JSONDecoder().decode(AllCategories.self, from: data)
            completion(.success(result.categories.items))
          }
          catch {
            completion(.failure(error))
          }

        }
        task.resume()
      }
    }
  }

  //MARK: - Get New Releases

  func getNewReleases(completion: @escaping (Result<NewReleases, Error>) -> Void) {

    authManager.withValidToken { token in
      self.createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=30"), type: .GET) { request in
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
          guard let data = data, error == nil else { return }
          do {
            let result = try JSONDecoder().decode(NewReleases.self, from: data)

            completion(.success(result))
          }
          catch {
            completion(.failure(error))
          }

        }
        task.resume()
      }

    }
  }

  //MARK: - Get Album Details

   func getAlbumDetails(for album: AlbumModel, completion: @escaping (Result<AlbumDetails, Error>) -> Void) {
      createRequest(
          with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
          type: .GET
      ) { request in
          let task = URLSession.shared.dataTask(with: request) { data, _, error in
              guard let data = data, error == nil else { return }
              do {
                  let result = try JSONDecoder().decode(AlbumDetails.self, from: data)
                  completion(.success(result))
              }
              catch {
                  completion(.failure(error))
              }
          }
          task.resume()
      }
  }

  //MARK: - Get Category Playlists

  func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
      createRequest(
          with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
          type: .GET
      ) { request in
          let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
              do {
                  let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                  let playlists = result.playlists.items
                  completion(.success(playlists))
              }
              catch {
                  completion(.failure(error))
              }
          }
          task.resume()
      }
  }

  // MARK: - Playlists

  func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
      createRequest(
          with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
          type: .GET
      ) { request in
          let task = URLSession.shared.dataTask(with: request) { data, _, error in
              guard let data = data, error == nil else { return }
              do {
                  let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                  completion(.success(result))
              }
              catch {
                  completion(.failure(error))
              }
          }
          task.resume()
      }
  }

  //MARK: - Recommended Genres

  func gerRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
      createRequest(
          with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
          type: .GET
      ) { request in
          let task = URLSession.shared.dataTask(with: request) { data, _, error in
              guard let data = data, error == nil else { return }

              do {
                  let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                  completion(.success(result))
              }
              catch {
                  completion(.failure(error))
              }
          }
          task.resume()
      }
  }

  //MARK: - get Recommendations

   func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
      let seeds = genres.joined(separator: ",")
      createRequest(
          with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
          type: .GET
      ) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
              guard let data = data, error == nil else { return }
              do {
                  let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                  completion(.success(result))
              }
              catch {
                  completion(.failure(error))
              }
          }
          task.resume()
      }
  }

//MARK: - Create Request

  private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
      authManager.withValidToken { token in
          guard let apiURL = url else { return }
          var request = URLRequest(url: apiURL)
          request.setValue("Bearer \(token)",
                           forHTTPHeaderField: HeaderKeys.authorization.rawValue)
          request.httpMethod = type.rawValue
          request.timeoutInterval = 30
          completion(request)
      }
  }



}


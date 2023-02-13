//
//  APICaller.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 29.01.23.
//

import Foundation

protocol APICallerProtocol {
  func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
  func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void)
  func getNewReleases(completion: @escaping (Result<NewReleases, Error>) -> Void)
  func getSeveralBrowseCategories(completion: @escaping (Result<SeveralBrowseCategories, Error>) -> Void)
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

  func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void) {
    authManager.withValidToken { token in
      self.createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists"), type: .GET) { request in
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
          guard let data = data, error == nil else { return }
          do {
            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

          }
          catch {
            completion(.failure(error))
          }
        }
        task.resume()
      }
    }
  }

//MARK: - Get Several Browse Categories

  func getSeveralBrowseCategories(completion: @escaping (Result<SeveralBrowseCategories, Error>) -> Void) {
    authManager.withValidToken { token in
      self.createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories"), type: .GET) { request in
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
          guard let data = data, error == nil else { return }
          do {
            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

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


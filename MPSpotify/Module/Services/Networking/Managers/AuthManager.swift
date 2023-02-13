//
//  AuthManager.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 24.01.23.
//

import Foundation

protocol AuthManagerProtocol {
  func signOut()
  func withValidToken(completion: @escaping (String) -> Void)
}

final class AuthManager: AuthManagerProtocol {

  //MARK: - Constants

  private enum Constants {
    static let clientID: String = "3cb143b1a7a54cde8cc2a41008835381"
    static let clientSecret: String = "557218c4ad764006a8b1c2eaad713555"
    static let redirectURI: String = "http://localhost:8888/callback"
    static let tokenURL: String = "https://accounts.spotify.com/api/token"
    static let headerValueContentType: String = "application/x-www-form-urlencoded"
    static let scopes: String = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
  }

  //MARK: - Properties

  private var refreshingToken = false

   var signInURL: URL? {
    let baseLink: String = "https://accounts.spotify.com/authorize"
     let url: String = "\(baseLink)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
    return URL(string: url)
  }

  var isSignedIn: Bool {
    return accessToken != nil
  }

  private var accessToken: String? {
    return UserDefaults.standard.string(forKey: AuthResponse.CodingKeys.accessToken.rawValue)
  }

  private var refreshToken: String? {
    return UserDefaults.standard.string(forKey: AuthResponse.CodingKeys.refreshToken.rawValue)
  }

  private var tokenEspirationDate: Date? {
    return UserDefaults.standard.object(forKey: AuthResponse.CodingKeys.expiresIn.rawValue) as? Date
  }

  private var shouldRefreshToken: Bool {
    guard let expirationDate = tokenEspirationDate else { return false }

    let currentDate = Date()
    let fiveMinutes = TimeInterval(300)
    return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
  }

  //MARK: - Authorization

  func exchangeCodeToAccessToken(code: String,
                                 complition: @escaping (Bool) -> Void) {
    guard let url = URL(string: Constants.tokenURL) else { return }

    var components = URLComponents()
    components.queryItems = [URLQueryItem(name: "grant_type",
                                          value: "authorization_code"),
                             URLQueryItem(name: "code",
                                          value: code),
                             URLQueryItem(name: "redirect_uri",
                                          value: Constants.redirectURI)
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(Constants.headerValueContentType, forHTTPHeaderField: HeaderKeys.contentType.rawValue)
    request.httpBody = components.query?.data(using: .utf8)

    let token = "\(Constants.clientID):\(Constants.clientSecret)"
    let data = token.data(using: .utf8)
    guard let base64String = data?.base64EncodedString() else {
      complition(false)
      return
    }
    request.setValue("Basic \(base64String)", forHTTPHeaderField: HeaderKeys.authorization.rawValue)

    let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
      guard let data = data, error == nil else {
        complition(false)
        return
      }
      do {
        let result = try JSONDecoder().decode(AuthResponse.self, from: data)
        self?.cacheAccessToken(result: result)
        complition(true)
        } catch {
          complition(false)
          print(error.localizedDescription)
        }
      }
    task.resume()
  }

  private var onRefreshBlocks = [((String) -> Void)]()

  func withValidToken(completion: @escaping (String) -> Void) {
      guard !refreshingToken else {
          onRefreshBlocks.append(completion)
          return
      }

      if shouldRefreshToken {
          refreshIfNeeded { [weak self] success in
              if let token = self?.accessToken, success {
                  completion(token)
              }
          }
      }
      else if let token = accessToken {
          completion(token)
      }
  }

  public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
      guard !refreshingToken else {
          return
      }

      guard shouldRefreshToken else {
          completion?(true)
          return
      }

      guard let refreshToken = self.refreshToken else{
          return
      }

      guard let url = URL(string: Constants.tokenURL) else {
          return
      }

      refreshingToken = true

      var components = URLComponents()
      components.queryItems = [
          URLQueryItem(name: "grant_type",
                       value: "refresh_token"),
          URLQueryItem(name: "refresh_token",
                       value: refreshToken),
      ]

      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue(Constants.headerValueContentType,
                       forHTTPHeaderField: HeaderKeys.contentType.rawValue)
      request.httpBody = components.query?.data(using: .utf8)

      let token = "\(Constants.clientID):\(Constants.clientSecret)"
      let data = token.data(using: .utf8)
      guard let base64String = data?.base64EncodedString() else {
          print("Failure to get base64")
          completion?(false)
          return
      }

      request.setValue("Basic \(base64String)",
                       forHTTPHeaderField: HeaderKeys.authorization.rawValue)

      let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
          self?.refreshingToken = false
          guard let data = data,
                error == nil else {
              completion?(false)
              return
          }

          do {
              let result = try JSONDecoder().decode(AuthResponse.self, from: data)
              self?.onRefreshBlocks.forEach { $0(result.accessToken) }
              self?.onRefreshBlocks.removeAll()
              self?.cacheAccessToken(result: result)
              completion?(true)
          }
          catch {
              print(error.localizedDescription)
              completion?(false)
          }
      }
      task.resume()
  }

  func cacheAccessToken(result: AuthResponse) {
    UserDefaults.standard.setValue(result.accessToken, forKey: AuthResponse.CodingKeys.accessToken.rawValue)
    if let refreshToken = result.refreshToken {
      UserDefaults.standard.setValue(refreshToken, forKey: AuthResponse.CodingKeys.refreshToken.rawValue)
    }

    UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresIn)), forKey: AuthResponse.CodingKeys.expiresIn.rawValue)
  }

  //MARK: - Sign Out

  func signOut() {
      UserDefaults.standard.setValue(nil,
                                     forKey: AuthResponse.CodingKeys.accessToken.rawValue)
      UserDefaults.standard.setValue(nil,
                                     forKey: AuthResponse.CodingKeys.refreshToken.rawValue)
      UserDefaults.standard.setValue(nil,
                                     forKey: AuthResponse.CodingKeys.expiresIn.rawValue)
  }

}

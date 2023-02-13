//
//  CategoryInfoViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 11.02.23.
//

import Foundation

protocol CategoryInfoViewModelProtocol {
  var category: Category { get }
  var complitionHandler: (() -> Void)? { get set }
  var playlists: [Playlist] { get }
  var apiCaller: APICallerProtocol { get }

  func getCategoryPlaylists()
}

final class CategoryInfoViewModel: CategoryInfoViewModelProtocol {

  var category: Category
  var playlists: [Playlist] = []
  var complitionHandler: (() -> Void)?
  var apiCaller: APICallerProtocol

  init(category: Category, apiCaller: APICallerProtocol) {
    self.category = category
    self.apiCaller = apiCaller
    getCategoryPlaylists()
  }

  func getCategoryPlaylists() {
    apiCaller.getCategoryPlaylists(category: category, completion: { result in
      switch result {
      case .success(let model):
        self.playlists = model
        DispatchQueue.main.async {
          self.complitionHandler?()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    })
  }
}

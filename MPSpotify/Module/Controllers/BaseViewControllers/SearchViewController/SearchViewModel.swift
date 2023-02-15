//
//  SearchViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 11.02.23.
//

import Foundation

protocol SearchViewModelProtocol {
  func getCategories()
  var categories: [Category] { get set }
  var searchResults: [SearchResult] { get set }
  var complitionHandler: (() -> Void)? { get set }
  var apiCaller: APICallerProtocol { get }
  func search(from text: String)
}

final class SearchViewModel {

  var apiCaller: APICallerProtocol
  var searchResults: [SearchResult] = []

  var categories: [Category] = []
  var complitionHandler: (() -> Void)? 

  init(apiCaller: APICallerProtocol) {
    self.apiCaller = apiCaller
    getCategories()
  }


  
}

extension SearchViewModel: SearchViewModelProtocol {

  func getCategories() {
    apiCaller.getCategories { result in
      switch result {
      case .success(let model):
        self.categories = model
        DispatchQueue.main.async {
          self.complitionHandler?()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  func search(from text: String) {

    apiCaller.search(with: text) { result in
      switch result {
      case .success(let model):
        self.searchResults = model
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

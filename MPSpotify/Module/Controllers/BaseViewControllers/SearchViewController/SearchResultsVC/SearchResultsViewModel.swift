//
//  SearchResultsViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 15.02.23.
//

import Foundation

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewModelProtocol {
  var sections: [SearchSection] { get set }
  var searchResults: [SearchResult] { get set }
}

final class SearchResultsViewModel {


 
}

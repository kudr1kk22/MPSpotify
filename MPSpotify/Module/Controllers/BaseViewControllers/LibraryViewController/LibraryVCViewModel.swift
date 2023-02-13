//
//  LibraryVCViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 1.02.23.
//

import Foundation

//protocol LibraryVCViewModelProtocol {
//  var models: [FeaturedPlaylists] { get }
//  var complitionHandler: (() -> Void)? { get set }
//
//  func fetchPlaylists()
//}

final class LibraryVCViewModel {

//  var models: [FeaturedPlaylists] = []
  var complitionHandler: (() -> Void)?
  private let apiCaller: APICallerProtocol

  init(apiCaller: APICaller) {
    self.apiCaller = apiCaller
  }



}

//extension LibraryVCViewModel: LibraryVCViewModelProtocol {
//  func fetchPlaylists() {
//    apiCaller.getFeaturedPlaylists { result in
//      switch result {
//      case .success(let model):
//        break
//      case .failure(let error):
//        print(error.localizedDescription)
//      }
//  }
//  }
//
//}

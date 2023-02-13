//
//  TabBarVCConfigurator.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 1.02.23.
//

import UIKit

final class TabBarVCConfigurator {


  static func makeProfileViewController() -> UIViewController {
    let viewModel = ProfileVCViewModel(apiCaller:
                                        APICaller(authManager: AuthManager()),
                                       authManager: AuthManager())
    let viewController = ProfileViewController(profileViewModel: viewModel)
    return viewController
  }

  static func makeLibraryViewController() -> UIViewController {
    //      let viewModel = LibraryVCViewModel()
    //      let viewController = LibraryViewController(libraryViewModel: viewModel)
    //      return viewController
    return UIViewController()
  }

  //TODO: change vm and vc
  
  static func makeSearchViewController() -> UIViewController {
          let viewModel = SearchViewModel(apiCaller: APICaller(authManager: AuthManager()))
          let viewController = SearchViewController(searchViewModel: viewModel)
          return viewController
  }

  static func makeHomeViewController() -> UIViewController {
    let viewModel = HomeVCViewModel(apiCaller:
                                      APICaller(authManager:
                                                  AuthManager()))
    let viewController = HomeViewController(homeVCViewModel: viewModel)
    return viewController
  }
  
}

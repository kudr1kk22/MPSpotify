//
//  ProfileVCViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 1.02.23.
//

import Foundation

protocol ProfileVCViewModelProtocol {
  var model: UserProfile? { get }
  var completionHandler: (() -> Void)? { get set }

  func fetchUserProfile()
  func signOut(completion: @escaping ((Bool) -> Void))
}

final class ProfileVCViewModel {

  //MARK: - Properties

  var model: UserProfile?
  var completionHandler: (() -> Void)?

  private let apiCaller: APICallerProtocol
  private let authManager: AuthManagerProtocol


  init(apiCaller: APICaller, authManager: AuthManager) {
    self.apiCaller = apiCaller
    self.authManager = authManager
  }


}

//MARK: - ProfileVCViewModelProtocol

extension ProfileVCViewModel: ProfileVCViewModelProtocol {
  func fetchUserProfile() {
    apiCaller.getCurrentUserProfile { [weak self] result in
      switch result {
      case .success(let model):
        self?.model = model
        DispatchQueue.main.async {
          self?.completionHandler?()
        }
      case .failure(let error):
        print("Error fetchUserProfile: \(error.localizedDescription)")
      }
    }
  }

  func signOut(completion: @escaping ((Bool) -> Void)) {
    authManager.signOut()
    completion(true)
  }





}




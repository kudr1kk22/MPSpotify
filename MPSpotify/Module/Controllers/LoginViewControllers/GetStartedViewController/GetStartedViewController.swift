//
//  GetStartedViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 4.01.23.
//

import UIKit

final class GetStartedViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet private weak var getStartedButton: UIButton!
    @IBOutlet private weak var infoTextView: UITextView!

  private let authManager = AuthManager()

    //MARK: - Actions
    
    @IBAction private func getStartedButtonDidTap() {
      guard let url = authManager.signInURL else { return }
      let signInVC = SignInViewController(url: url, title: "Spotify", authManager: authManager)
      signInVC.complitionHandler = { [weak self] success in
        DispatchQueue.main.async {
          self?.handleSignIn(success: success)
        }
      }
        present(signInVC, animated: true)
    }
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfoTextView()
        setupGetStartedButton()
    }
    
    //MARK: - Metods
    
    private func setupInfoTextView() {
        infoTextView.textColor = .systemGray4
        infoTextView.backgroundColor = .clear
        infoTextView.isSelectable = false
    }
    
    private func setupGetStartedButton() {
        getStartedButton.layer.cornerRadius = 25
    }

    private func handleSignIn(success: Bool) {
      guard success else { return }
      AppDelegate.presentMainWindow()
  }


}


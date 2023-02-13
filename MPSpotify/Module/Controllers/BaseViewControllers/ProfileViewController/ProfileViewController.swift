//
//  ProfileViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 24.01.23.
//

import UIKit


final class ProfileViewController: UIViewController {

  //MARK: - IBOutlets

  @IBOutlet private weak var profileImage: UIImageView!
  @IBOutlet private weak var emailLabel: UILabel!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var followersLabel: UILabel!
  @IBOutlet private weak var followingLabel: UILabel!
  @IBOutlet private weak var productTypeLabel: UILabel!
  @IBOutlet private weak var signOutButton: UIButton!
  @IBOutlet private weak var idLabel: UILabel!
  @IBOutlet private weak var explicitContent: UILabel!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

  //MARK: - Properties

  private var profileViewModel: ProfileVCViewModelProtocol

  //MARK: - Initialization

  init(profileViewModel: ProfileVCViewModelProtocol) {
      self.profileViewModel = profileViewModel
      super.init(nibName: "\(ProfileViewController.self)", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Life Cycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()

  }


  override func viewDidLoad() {
    super.viewDidLoad()
    setGradientLayer()
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    bind()

    profileViewModel.fetchUserProfile()
    }

  func setGradientLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    self.view.layer.insertSublayer(gradientLayer, at: 0)
  }

  //MARK: - Binding

  private func bind() {
    profileViewModel.completionHandler = {
          print("Content updated")
      guard let model = self.profileViewModel.model else { return }
      self.activityIndicator.isHidden = true
      self.activityIndicator.stopAnimating()
      self.updateUI(with: model)
      }
  }

  //MARK: - Setup UI elements

  private func setupUI() {
    let height = signOutButton.bounds.height
    signOutButton.layer.cornerRadius = height / 2
    profileImage.makeRounded()
  }

//MARK: - IBActions

  @IBAction private func signOutButtonDidTap() {
    let alert = UIAlertController(title: "Sign Out",
                                  message: "Are you sure?",
                                  preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "Cancel",
                                   style: .cancel,
                                   handler: nil))
     alert.addAction(UIAlertAction(title: "Sign Out",
                                   style: .destructive,
                                   handler: { _ in
       self.profileViewModel.signOut { signedOut in
         DispatchQueue.main.async {
           AppDelegate.presentGetStartedWindow()
         }
       }
     }))
     present(alert, animated: true)
 }

  //MARK: - Update UI elements from model

private func updateUI(with model: UserProfile) {
  emailLabel.text = model.email
  nameLabel.text = model.displayName
  productTypeLabel.text = model.product
  followersLabel.text = "\(model.followers.total)"
  idLabel.text = model.id
  if let explicit = model.explicitContent.first?.value {
    explicitContent.text = explicit ? "NO" : "YES"
  }

  if let imageURL = URL(string: model.images.first?.url ?? "") {
    if let imageData = try? Data(contentsOf: imageURL) {
      DispatchQueue.main.async {
        self.profileImage.image = UIImage(data: imageData)
      }
    }
  }
}
}



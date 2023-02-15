//
//  TabBarViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 24.01.23.
//

import UIKit

final class TabBarViewController: UITabBarController {

//MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setTabBar()
//    setGradientLayer()
  }

  func setGradientLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    self.view.layer.insertSublayer(gradientLayer, at: 0)
  }

  //MARK: - Set TabBar

  private func setTabBar() {
    let homeVC = TabBarVCConfigurator.makeHomeViewController()
    let searchVC = TabBarVCConfigurator.makeSearchViewController()
    let profileVC = TabBarVCConfigurator.makeProfileViewController()

    homeVC.title = "Discovery"
    searchVC.title = "Search"
    profileVC.title = "Profile"

    homeVC.navigationItem.largeTitleDisplayMode = .always
    searchVC.navigationItem.largeTitleDisplayMode = .always
    profileVC.navigationItem.largeTitleDisplayMode = .always

    let homeVCnavigationController = UINavigationController(rootViewController: homeVC)
    let searchVCnavigationController = UINavigationController(rootViewController: searchVC)
    let profileVCnavigationController = UINavigationController(rootViewController:  profileVC)

    homeVCnavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "music.note.house.fill"), tag: 0)
    searchVCnavigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), tag: 1)
    profileVCnavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 3)

    homeVCnavigationController.navigationBar.prefersLargeTitles = true
    searchVCnavigationController.navigationBar.prefersLargeTitles = true
    profileVCnavigationController.navigationBar.prefersLargeTitles = true

    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

    homeVCnavigationController.navigationBar.largeTitleTextAttributes = textAttributes
    searchVCnavigationController.navigationBar.largeTitleTextAttributes = textAttributes
    profileVCnavigationController.navigationBar.largeTitleTextAttributes = textAttributes

    let navigationBarColor = UIColor.black

    homeVCnavigationController.navigationBar.titleTextAttributes = textAttributes
    searchVCnavigationController.navigationBar.titleTextAttributes = textAttributes
    profileVCnavigationController.navigationBar.titleTextAttributes = textAttributes

    homeVCnavigationController.navigationBar.barTintColor = navigationBarColor
    searchVCnavigationController.navigationBar.barTintColor = navigationBarColor
    profileVCnavigationController.navigationBar.barTintColor = navigationBarColor

    homeVCnavigationController.navigationBar.tintColor = .white
    searchVCnavigationController.navigationBar.tintColor = .white
    profileVCnavigationController.navigationBar.tintColor = .white

    tabBar.tintColor = .systemGreen
    tabBar.barTintColor = .black


    setViewControllers([homeVCnavigationController, searchVCnavigationController, profileVCnavigationController], animated: false)
  }



}



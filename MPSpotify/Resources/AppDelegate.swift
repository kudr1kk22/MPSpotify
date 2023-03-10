//
//  AppDelegate.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 4.01.23.
//

import UIKit
import AVKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let audioSession = AVAudioSession.sharedInstance()
     do {
       try audioSession.setCategory(.playback, mode: .default)
//         try audioSession.setActive(true)
     } catch let error as NSError {
         print("Setting category to AVAudioSessionCategoryPlayback failed: \(error)")
     }
     return true
 }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  static func presentMainWindow() {
    guard let window = UIApplication.shared.windows.first else { return }
    window.rootViewController = TabBarViewController(nibName: "\(TabBarViewController.self)", bundle: nil)
    window.makeKeyAndVisible()
  }

  static func presentGetStartedWindow() {
    guard let window = UIApplication.shared.windows.first else { return }
    window.rootViewController = GetStartedViewController(nibName: "\(GetStartedViewController.self)", bundle: nil)
    window.makeKeyAndVisible()
  }


  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}


//
//  SignInViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 5.01.23.
//


import UIKit
import WebKit

final class SignInViewController: UIViewController, WKNavigationDelegate {

  //MARK: - Properties
    
    @IBOutlet private weak var signInWebView: WKWebView!

    private let authManager: AuthManager
    private let url: URL
    var complitionHandler: ((Bool) -> Void)?

  //MARK: - Initialization
    
  init(url: URL, title: String, authManager: AuthManager) {
        self.url = url
        self.authManager = authManager
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

  //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let preferenses = WKWebpagePreferences()
        //preferenses.allowsContentJavaScript = true
        signInWebView.navigationDelegate = self
        signInWebView.load(URLRequest(url: url))
    }
    
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    guard let url = webView.url else { return }
    let component = URLComponents(string: url.absoluteString)
    guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else { return }

    webView.isHidden = true

    authManager.exchangeCodeToAccessToken(code: code) { [weak self] success in
      DispatchQueue.main.async {
        self?.dismiss(animated: true)
        self?.complitionHandler?(success)
      }
    }
  }
    
}

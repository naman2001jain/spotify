//
//  AuthViewController.swift
//  spotify
//
//  Created by Naman Jain on 12/05/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController,WKNavigationDelegate {

    private let webView: WKWebView = {
        
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool)->(Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.navigationDelegate = self
        guard let url = AuthManager.sharedInstance.signInUrl else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        print("code=\(code)")
        
        AuthManager.sharedInstance.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.completionHandler?(success)
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

}

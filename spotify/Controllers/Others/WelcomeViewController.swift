//
//  WelcomeViewController.swift
//  spotify
//
//  Created by Naman Jain on 12/05/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in to spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spotify"
        view.backgroundColor = .systemRed
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSign), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - view.safeAreaInsets.bottom - 50,
            width: view.width - 40,
            height: 50)
    }
    
    @objc func didTapSign(){
        let vc = AuthViewController()
        
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool){
        //log user in or yell at them for error
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Error while signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
        
    }
    
}

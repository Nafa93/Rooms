//
//  SignInViewController.swift
//  rooms
//
//  Created by Nicolas Fernandez Amorosino on 22/02/2018.
//  Copyright © 2018 Nicolas Amorosino. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    let defaults = UserDefaults.standard
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        let googleSignInButton = GIDSignInButton()
        view.addSubview(googleSignInButton)
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        googleSignInButton.style = .wide
        
        let leftConstraint = googleSignInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 22)
        
        let rightConstraint = googleSignInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -22)
        
        let bottomConstraint = googleSignInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64)
        
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, bottomConstraint])
        
//        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    
    override internal func didReceiveMemoryWarning() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = defaults.string(forKey: "UserToken"){
            print("you're logged in")
//            NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
            performSegue(withIdentifier: "goToHome", sender: self)
        } else {
            print("you're not")
        }
    }
    
    @objc func userDefaultsDidChange(_ notification: Notification) {
        print(notification.description)

        if let token = defaults.string(forKey: "UserToken"){
            print("you're logged in")
            NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)

        } else {
            print("you're not")
        }
    }
}

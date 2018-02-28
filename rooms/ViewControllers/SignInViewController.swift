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
    
    let viewAndToken : ViewAndToken = ViewAndToken()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        self.createGoogleButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didViewAppearedAndTokenObtained), name: Notification.Name("ViewAndToken"), object: nil)
    }
    
    @objc func userDefaultsDidChange(_ notification: Notification) {
        if defaults.string(forKey: "UserToken") != nil{
            viewAndToken.TokenObtained = true
        } else {
            viewAndToken.TokenObtained = false
        }
        NotificationCenter.default.post(name: Notification.Name("ViewAndToken"), object: viewAndToken)
    }
    
    @objc func didViewAppearedAndTokenObtained(_ notification: Notification) {
        if viewAndToken.TokenObtained && viewAndToken.ViewAppeared {
            performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewAndToken.ViewAppeared = true
        NotificationCenter.default.post(name: Notification.Name("ViewAndToken"), object: viewAndToken)
    }

    func createGoogleButton(){
        let googleSignInButton = GIDSignInButton()
        view.addSubview(googleSignInButton)
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        googleSignInButton.style = .wide
        
        let leftConstraint = googleSignInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 22)
        
        let rightConstraint = googleSignInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -22)
        
        let bottomConstraint = googleSignInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64)
        
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, bottomConstraint])
    }
}

//
//  SignInViewController.swift
//  rooms
//
//  Created by Nicolas Fernandez Amorosino on 22/02/2018.
//  Copyright © 2018 Nicolas Amorosino. All rights reserved.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBAction func didTapSignOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        
        self.defaults.removeObject(forKey: "UserToken")
        
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    let defaults = UserDefaults.standard
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = defaults.string(forKey: "UserGivenName") {
            helloLabel.text = "Hello \(name.description)!"
        }
    }
    
    override internal func didReceiveMemoryWarning() {
        
    }
}


//
//  GoogleSignInDelegate.swift
//  rooms
//
//  Created by Nicolas Fernandez Amorosino on 28/02/2018.
//  Copyright © 2018 Nicolas Amorosino. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleSignInDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "831709529992-g4j6hjrrpqtfeurcnftf940i70h3un2g.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        let defaults = UserDefaults.standard
        
        if let error = error {
            print("\(error.localizedDescription)")
            
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID.description                 // For client-side use only!
            let idToken = user.authentication.idToken.description // Safe to send to the server
            let fullName = user.profile.name.description
            let givenName = user.profile.givenName.description
            let familyName = user.profile.familyName.description
            let email = user.profile.email.description
            // ...
            print(userId, idToken, fullName, givenName, familyName, email, fullName)
            
            let user = User(id: userId, token: idToken, completeName: fullName, firstName: givenName, lastName: familyName, mail: email)
            
            defaults.set(user.idToken, forKey: "UserToken")
            defaults.set(user.givenName, forKey: "UserGivenName")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

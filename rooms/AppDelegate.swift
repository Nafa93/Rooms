//
//  AppDelegate.swift
//  rooms
//
//  Created by Nicolas Fernandez Amorosino on 19/02/2018.
//  Copyright © 2018 Nicolas Amorosino. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "831709529992-g4j6hjrrpqtfeurcnftf940i70h3un2g.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
            print(user.authentication.idToken.description)
            print(user.authentication.clientID.description)
            
            let parameters: Parameters = [
                "token": user.authentication.idToken.description,
                "client_id": user.authentication.clientID.description
            ]
            
            defaults.set(user.authentication.idToken.description, forKey: "UserToken")
            defaults.set(user.profile.givenName.description, forKey: "UserGivenName")
            
            print(parameters)
            
//            Alamofire.request("http://192.168.0.12:3001/setToken", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
//                response in
//                if response.result.isSuccess {
//                    print("token received!")
//                } else {
//                    print("something went wrong")
//                }
////                print(response.result.value!)
//            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}


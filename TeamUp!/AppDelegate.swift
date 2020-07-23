//
//  AppDelegate.swift
//  TeamUp!
//
//  Created by Alicia Ho on 22/5/20.
//  Copyright © 2020 Alicia Ho. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .red
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: ProfileViewController())
        
        //UINavigationBar.appearance().barTintColor = UIColor.yellow
        //UINavigationBar.appearance().tintColor = UIColor.orange
        
     /*
        //use ios font to find the suitable font
        let navigationFont = UIFont(name: "AmericanTypewriter", size: 18)
        let navigationFontAttributes = [NSAttributedString.Key.font: navigationFont]
        UINavigationBar.appearance().titleTextAttributes = navigationFontAttributes as [NSAttributedString.Key : Any]
        UIBarButtonItem.appearance().setTitleTextAttributes(navigationFontAttributes as [NSAttributedString.Key : Any], for: .normal)
 */
        
        //let db = Firestore.firestore()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


//
//  AppDelegate.swift
//  TikiTacToe
//
//  Created by Pro on 27.01.2021.
//

import UIKit
import OneSignal
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.object(forKey: "sound") as? String ?? "1" == "1" {
            BackSound.sharedInstance().playBGMusic()
        } else {
            UserDefaults.standard.set("0", forKey: "play")
        }
        
        // MARK: - OneSignal
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("961d3d2b-3416-4918-8a9b-0b2ba1454a15")
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // MARK: - FB
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}


//
//  AppDelegate.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/18.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        
        return true
    }
}


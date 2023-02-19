//
//  AppDelegate.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        
        return true
    }
}


//
//  AppDelegate.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/18.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { [weak self] status in
                    switch status {
                    case .authorized:
                        print("🎉")
                        //IDFA取得
                        print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
                        break
                    case .denied:
                        print("denied 😭")
                        break
                    case  .restricted:
                        print("restricted 😭")
                        break
                    case   .notDetermined:
                        print("not determinded😭")
                        break
                    }
                })
            } else {
                // Fallback on earlier versions
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("通知が許可された")
            } else {
                print("通知が許可されていない")
            }
        }
        
        return true
    }
}

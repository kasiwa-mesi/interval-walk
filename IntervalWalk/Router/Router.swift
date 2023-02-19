//
//  Router.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/19.
//

import UIKit

final class Router {
    static let shared: Router = .init()
    private init() {}
    
    private var window: UIWindow?
    
    func showRoot(window: UIWindow?) {
        let vc = RegisterViewController.makeFromStoryboard()
        self.pushNavigate(vc: vc, window: window)
    }
}

private extension Router {
    func show(from: UIViewController, next: UIViewController, animated: Bool = true) {
        if let nav = from.navigationController {
            nav.pushViewController(next, animated: animated)
        } else {
            from.present(next, animated: animated, completion: nil)
        }
    }
    
    func pushNavigate(vc: UIViewController, window: UIWindow?) {
        let navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        self.window = window
    }
}

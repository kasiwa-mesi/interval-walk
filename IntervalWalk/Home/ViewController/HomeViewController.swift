//
//  HomeViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import UIKit

final class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> HomeViewController {
        guard let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController() as? HomeViewController else {
            fatalError()
        }
        return vc
    }
}

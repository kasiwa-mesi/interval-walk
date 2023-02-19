//
//  RegisterViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/19.
//

import UIKit

final class RegisterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func makeFromStoryboard() -> RegisterViewController {
        guard let vc = UIStoryboard.init(name: "Register", bundle: nil).instantiateInitialViewController() as? RegisterViewController else {
            fatalError()
        }
        return vc
    }
}

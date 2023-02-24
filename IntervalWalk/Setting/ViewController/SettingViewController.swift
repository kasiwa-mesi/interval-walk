//
//  SettingViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import UIKit

final class SettingViewController: UIViewController {
    @IBOutlet private weak var moveSetPasswordChangedButton: UIButton! {
        didSet {
            moveSetPasswordChangedButton.addTarget(self, action: #selector(tapMoveSetPasswordChangedButton), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var moveSetEmailChangedButton: UIButton! {
        didSet {
            moveSetEmailChangedButton.addTarget(self, action: #selector(tapMoveSetEmailChangedButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SettingViewController {
        guard let vc = UIStoryboard.init(name: "Setting", bundle: nil).instantiateInitialViewController() as? SettingViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension SettingViewController {
    func tapMoveSetEmailChangedButton() {
        Router.shared.showSetEmailChanged(from: self)
    }
    
    func tapMoveSetPasswordChangedButton() {
        Router.shared.showSetPasswordChanged(from: self)
    }
}

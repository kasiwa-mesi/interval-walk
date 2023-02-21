//
//  SetPasswordChangedViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import UIKit

final class SetPasswordChangedViewController: UIViewController {
    @IBOutlet private weak userEmailLabel: UILabel!
    @IBOutlet private weak setPasswordChangedButton: UIButton! {
        didSet {
            setPasswordChangedButton.addTarget(self, action: #selector(tapPasswordChangeButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> SetPasswordChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetPasswordChanged", bundle: nil).instantiateInitialViewController() as? SetPasswordChangedViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension SetPasswordChangedViewController {
    func tapPasswordChangeButton() {
        // Presenterでパスワードリセットの処理を実装
    }
}

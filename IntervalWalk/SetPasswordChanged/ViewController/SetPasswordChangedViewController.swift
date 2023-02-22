//
//  SetPasswordChangedViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import UIKit

final class SetPasswordChangedViewController: UIViewController {
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var setPasswordChangedButton: UIButton! {
        didSet {
            setPasswordChangedButton.addTarget(self, action: #selector(tapPasswordChangeButton), for: .touchUpInside)
        }
    }
    
    private var presenter: SetPasswordChangedPresenterInput!
    func inject(presenter: SetPasswordChangedPresenterInput) {
      self.presenter = presenter
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
        presenter.passwordReset()
    }
}

extension SetPasswordChangedViewController: SetPasswordChangedPresenterOutput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}

//
//  SetEmailChangedViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/22.
//

import UIKit

final class SetEmailChangedViewController: UIViewController {
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var setEmailChangedButton: UIButton! {
        didSet {
            setEmailChangedButton.addTarget(self, action: #selector(tapSetEmailChangeButton), for: .touchUpInside)
        }
    }
    
    private var presenter: SetEmailChangedPresenterInput!
    func inject(presenter: SetEmailChangedPresenterInput) {
      self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.isLogined()
    }
    
    static func makeFromStoryboard() -> SetEmailChangedViewController {
        guard let vc = UIStoryboard.init(name: "SetEmailChanged", bundle: nil).instantiateInitialViewController() as? SetEmailChangedViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension SetEmailChangedViewController {
    func tapSetEmailChangeButton() {
        let newEmail = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        presenter.updateEmail(newEmail: newEmail, password: password)
    }
}

extension SetEmailChangedViewController: SetEmailChangedPresenterOutput {
    func show(validationMessage: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        self.showAlert(title: validationMessage, message: "", actions: [gotItAction])
    }
    
    func showLoginAlert() {
        let moveLoginAction = UIAlertAction(title: String.loginActionButtonLabel, style: .default) { _ in
            self.presenter.logOut()
        }
        self.showAlert(title: String.loginAlertTitle, message: "", actions: [moveLoginAction])
    }
    
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}


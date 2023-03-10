//
//  RegisterViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/19.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var reconfirmPasswordTextField: UITextField!
    
    
    @IBOutlet private weak var registerButton: UIButton! {
        didSet {
            registerButton.addTarget(self, action: #selector(tapRegisterButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var moveLoginScreenButton: UIButton! {
        didSet {
            moveLoginScreenButton.addTarget(self, action: #selector(tapMoveLoginScreenButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var moveTrialButton: UIButton! {
        didSet {
            moveTrialButton.addTarget(self, action: #selector(tapMoveTrialButton), for: .touchUpInside)
        }
    }
    
    private var presenter: RegisterPresenterInput!
    func inject(presenter: RegisterPresenterInput) {
      self.presenter = presenter
    }
    
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

@objc private extension RegisterViewController {
    func tapMoveLoginScreenButton() {
        Router.shared.showLogin(from: self)
    }
    
    func tapRegisterButton() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let reconfirmPassword = reconfirmPasswordTextField.text ?? ""
        
        presenter.createUser(email: email, password: password, reconfirmPassword: reconfirmPassword)
    }
    
    func tapMoveTrialButton() {
        Router.shared.showTrial(from: self)
    }
}

extension RegisterViewController: RegisterPresenterOutput {
    func show(validationMessage: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        self.showAlert(title: validationMessage, message: "", actions: [gotItAction])
    }
    
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}

//
//  LoginViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var moveRegisterButton: UIButton! {
        didSet {
            moveRegisterButton.addTarget(self, action: #selector(tapMoveRegisterButton), for: .touchUpInside)
        }
    }
    
    private var presenter: LoginPresenterInput!
    func inject(presenter: LoginPresenterInput) {
      self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func makeFromStoryboard() -> LoginViewController {
        guard let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension LoginViewController {
    func tapLoginButton() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        presenter.signIn(email: email, password: password)
    }
    
    func tapMoveRegisterButton() {
        Router.shared.showRegister(from: self)
    }
}

extension LoginViewController: LoginPresenterOutput {
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


//
//  LoginPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import Foundation

protocol LoginPresenterInput {
    func showErrorAlert(error: NSError?)
    func signIn(email: String, password: String)
}

protocol LoginPresenterOutput: AnyObject {
    func show(validationMessage: String)
    func showErrorAlert(code: String, message: String)
}

final class LoginPresenter {
    private var output: LoginPresenterOutput!
    init(output: LoginPresenterOutput) {
        self.output = output
    }
}

extension LoginPresenter: LoginPresenterInput {
    func signIn(email: String, password: String) {
        if let validationAlertMessage = Validator(email: email, password: password, reconfirmPassword: nil)?.alertMessage {
            output.show(validationMessage: validationAlertMessage)
            return
        }
        
        AuthService.shared.signIn(email: email, password: password) { error in
            if let error {
                self.output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
        }
    }
    
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
}

//
//  SetEmailChangedPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/22.
//

import Foundation

protocol SetEmailChangedPresenterInput {
    var email: String { get }
    func showErrorAlert(error: NSError?)
    func updateEmail(newEmail: String, password: String)
    func logOut()
    func isLogined()
}

protocol SetEmailChangedPresenterOutput: AnyObject {
    func show(validationMessage: String)
    func showLoginAlert()
    func showErrorAlert(code: String, message: String)
}

final class SetEmailChangedPresenter {
    private var _email: String
    var email: String {
        get {
            return _email
        }
    }
    
    private var output: SetEmailChangedPresenterOutput!
    init(output: SetEmailChangedPresenterOutput) {
        let email = AuthService.shared.getCurrentUserEmail()
        self._email = email ?? ""
        self.output = output
    }
}

extension SetEmailChangedPresenter: SetEmailChangedPresenterInput {
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
    
    func updateEmail(newEmail: String, password: String) {
        if let validationAlertMessage = Validator(email: newEmail, password: nil, reconfirmPassword: nil)?.alertMessage {
            output.show(validationMessage: validationAlertMessage)
            return
        }
        
        let credential = AuthService.shared.getCredential(email: email, password: password)
        AuthService.shared.reAuthenticate(credential: credential) { error in
            if let error {
                self.output.showLoginAlert()
                return
            }
        }
        
        AuthService.shared.updateEmail(email: newEmail) { error in
            if let error {
                self.output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            Router.shared.showReStart()
        }
    }
    
    func isLogined() {
        if email.isEmpty {
            self.output.showLoginAlert()
        }
    }
    
    func logOut() {
        AuthService.shared.signOut { error in
            self.showErrorAlert(error: error)
        }
    }
}

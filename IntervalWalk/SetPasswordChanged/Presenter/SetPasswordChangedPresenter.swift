//
//  SetPasswordChangedPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import Foundation

protocol SetPasswordChangedPresenterInput {
    func showErrorAlert(error: NSError?)
    func passwordReset()
}

protocol SetPasswordChangedPresenterOutput: AnyObject {
    func showErrorAlert(code: String, message: String)
}

final class SetPasswordChangedPresenter {
    private var _email: String
    var email: String {
        get {
            return _email
        }
    }
    
    private var output: SetPasswordChangedPresenterOutput!
    init(output: SetPasswordChangedPresenterOutput) {
        let email = AuthService.shared.getCurrentUserEmail()
        self._email = email ?? ""
        self.output = output
    }
}

extension SetPasswordChangedPresenter: SetPasswordChangedPresenterInput {
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
    
    func passwordReset() {
        AuthService.shared.sendPasswordReset(email: self.email) { error in
            if let error {
                self.output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
                return
            }
            
            Router.shared.showReStart()
        }
    }
}

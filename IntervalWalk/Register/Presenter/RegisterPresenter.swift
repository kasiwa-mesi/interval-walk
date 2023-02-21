//
//  RegisterPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/20.
//

import Foundation


protocol RegisterPresenterInput {
    func showErrorAlert(error: NSError?)
    func createUser(email: String, password: String, reconfirmPassword: String)
}

protocol RegisterPresenterOutput: AnyObject {
    func show(validationMessage: String)
    func showErrorAlert(code: String, message: String)
}

final class RegisterPresenter {
    private var output: RegisterPresenterOutput!
    // このoutputがViewControllerのこと
    init(output: RegisterPresenterOutput) {
        self.output = output
    }
}

extension RegisterPresenter: RegisterPresenterInput {
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
    
    func createUser(email: String, password: String, reconfirmPassword: String) {
        if let validationAlertMessage = Validator(email: email, password: password, reconfirmPassword: reconfirmPassword)?.alertMessage {
            output.show(validationMessage: validationAlertMessage)
            return
        }
        
        AuthService.shared.createUser(email: email, password: password) { (error) in
            self.showErrorAlert(error: error)
            
            AuthService.shared.setLanguageCode(code: String.languageCode)
            AuthService.shared.sendEmailVerification { error in
                self.showErrorAlert(error: error)
            }
        }
    }
}

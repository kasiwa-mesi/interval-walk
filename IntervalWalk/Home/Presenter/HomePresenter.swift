//
//  HomePresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/22.
//

import Foundation

protocol HomePresenterInput {
    func logOut()
    func showErrorAlert(error: NSError?)
}

protocol HomePresenterOutput: AnyObject {
    func showErrorAlert(code: String, message: String)
}


final class HomePresenter {
    private var output: HomePresenterOutput!
    init(output: HomePresenterOutput) {
        self.output = output
    }
}

extension HomePresenter: HomePresenterInput {
    func logOut() {
        AuthService.shared.signOut { error in
            self.showErrorAlert(error: error)
        }
    }
    
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
}

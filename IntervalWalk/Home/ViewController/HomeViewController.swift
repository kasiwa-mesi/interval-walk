//
//  HomeViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import UIKit

final class HomeViewController: UIViewController {
    private var signOutButtonItem: UIBarButtonItem!
    
    private var presenter: HomePresenterInput!
    func inject(presenter: HomePresenterInput) {
      self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signOutButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(tapSignOutButton))
        
        self.navigationItem.leftBarButtonItem = signOutButtonItem
    }
    
    static func makeFromStoryboard() -> HomeViewController {
        guard let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController() as? HomeViewController else {
            fatalError()
        }
        return vc
    }
}

@objc private extension HomeViewController {
    func tapSignOutButton() {
        // presenterを利用してログアウト機能を実装する
        presenter.logOut()
    }
}

extension HomeViewController: HomePresenterOutput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}

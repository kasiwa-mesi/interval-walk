//
//  HomeViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/21.
//

import UIKit

final class HomeViewController: UIViewController {
    private var signOutButtonItem: UIBarButtonItem!
    private var moveSettingButtonItem: UIBarButtonItem!
    private var moveRecordButtonItem: UIBarButtonItem!
    
    @IBOutlet private weak var moveStopwatchButton: UIButton! {
        didSet {
            moveStopwatchButton.addTarget(self, action: #selector(tapMoveStopwatchButton), for: .touchUpInside)
        }
    }
    
    
    private var presenter: HomePresenterInput!
    func inject(presenter: HomePresenterInput) {
      self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signOutButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(tapSignOutButton))
        moveSettingButtonItem = UIBarButtonItem(title: "設定", style: .done, target: self, action: #selector(tapMoveSettingButton))
        moveRecordButtonItem = UIBarButtonItem(image: UIImage(systemName: "archivebox"), style: .done, target: self, action: #selector(tapMoveRecordButton))
        
        self.navigationItem.leftBarButtonItem = signOutButtonItem
        self.navigationItem.rightBarButtonItems = [moveSettingButtonItem, moveRecordButtonItem]
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
    
    func tapMoveSettingButton() {
        print("設定画面に移動")
    }
    
    func tapMoveRecordButton() {
        print("記録画面に移動")
        Router.shared.showRecord(from: self)
    }
    
    func tapMoveStopwatchButton() {
        Router.shared.showStopwatch(from: self)
    }
}

extension HomeViewController: HomePresenterOutput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}

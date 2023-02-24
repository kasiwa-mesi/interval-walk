//
//  RecordViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import UIKit

final class RecordViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.isHidden = true
        }
    }
    @IBOutlet private weak var howToView: UIView! {
        didSet {
            howToView.isHidden = false
        }
    }
    @IBOutlet private weak var startButton: UIButton!
    
    private var presenter: RecordPresenterInput!
    func inject(presenter: RecordPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.fetchRecords()
    }
    
    static func makeFromStoryboard() -> RecordViewController {
        guard let vc = UIStoryboard.init(name: "Record", bundle: nil).instantiateInitialViewController() as? RecordViewController else {
            fatalError()
        }
        return vc
    }
}

extension RecordViewController: RecordPresenterOutput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}

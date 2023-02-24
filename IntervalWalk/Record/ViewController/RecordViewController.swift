//
//  RecordViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import UIKit

final class RecordViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        }
    }
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
    @IBOutlet private weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        }
    }
    
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

@objc private extension RecordViewController {
    func tapStartButton() {
        Router.shared.showStopwatch(from: self)
    }
}

extension RecordViewController: RecordPresenterOutput {
    func update(loading: Bool) {
        indicator.isHidden = !loading
        indicator.startAnimating()
        tableView.isHidden = loading
        howToView.isHidden = loading
    }
    
    func showHowToView() {
        howToView.isHidden = false
        tableView.isHidden = true
        indicator.isHidden = true
    }
    
    func updateRecordModels() {
        tableView.isHidden = false
        indicator.isHidden = true
        howToView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
}

extension RecordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RecordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let recordModel = presenter.item(index: indexPath.item)
        cell.configure(record: recordModel)
        return cell
    }
}


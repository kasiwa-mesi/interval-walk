//
//  StopwatchViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/23.
//

import UIKit
import AVFoundation

final class StopwatchViewController: UIViewController {
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        }
    }
    @IBOutlet weak var finishButton: UIButton! {
        didSet {
            finishButton.addTarget(self, action: #selector(tapFinishButton), for: .touchUpInside)
        }
    }
    
    private var presenter: StopwatchPresenterInput!
    func inject(presenter: StopwatchPresenterInput) {
      self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .bold)

        updateStartButton()
    }
    
    static func makeFromStoryboard() -> StopwatchViewController {
        guard let vc = UIStoryboard.init(name: "Stopwatch", bundle: nil).instantiateInitialViewController() as? StopwatchViewController else {
            fatalError()
        }
        return vc
    }
}

private extension StopwatchViewController {
    func updateStartButton() {
        let title = presenter.getStartButtonTitle()
        startButton.setTitle(title, for: .normal)
        
        updateTimerLabel()
    }
}

@objc private extension StopwatchViewController {
    func tapStartButton() {
        presenter.playStartSound()
        presenter.setStateChanged()
        updateStartButton()
    }
    
    func tapFinishButton() {
        presenter.reset()
        updateStartButton()
        Router.shared.showReStart()
    }
}

extension StopwatchViewController: StopwatchPresenterOutput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default)
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
    
    func updateTimerLabel() {
        presenter.setTimerLabelUpdated()
        timerLabel.text = presenter.timerLabel
    }
}

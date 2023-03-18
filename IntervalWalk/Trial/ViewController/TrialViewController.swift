//
//  TrialViewController.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import UIKit
import AVFoundation

final class TrialViewController: UIViewController {
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var walkingImage: UIImageView!
    @IBOutlet private weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var finishButton: UIButton! {
        didSet {
            finishButton.addTarget(self, action: #selector(tapFinishButton), for: .touchUpInside)
        }
    }
    
    private var presenter: TrialPresenterInput!
    func inject(presenter: TrialPresenterInput) {
      self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .bold)

        updateStartButton()
    }
    
    static func makeFromStoryboard() -> TrialViewController {
        guard let vc = UIStoryboard.init(name: "Trial", bundle: nil).instantiateInitialViewController() as? TrialViewController else {
            fatalError()
        }
        return vc
    }
}

private extension TrialViewController {
    func updateStartButton() {
        let title = presenter.getStartButtonTitle()
        startButton.setTitle(title, for: .normal)
        
        updateTimerLabel()
    }
}

@objc private extension TrialViewController {
    func tapStartButton() {
        presenter.playStartSound()
        presenter.setStateChanged()
        updateStartButton()
    }
    
    func tapFinishButton() {
        presenter.reset()
        updateStartButton()
    }
}

extension TrialViewController: TrialPresenterOutput {
    func showErrorAlert(code: String, message: String) {
        let gotItAction = UIAlertAction(title: String.ok, style: .default) { _ in
            Router.shared.showReStart()
        }
        let errorTitle = String.errorTitle + code
        self.showAlert(title: errorTitle, message: message, actions: [gotItAction])
    }
    
    func updateTimerLabel() {
        presenter.setTimerLabelUpdated()
        timerLabel.text = presenter.timerLabel
    }
    
    func setSpeedLabelSpeedy() {
        speedLabel.text = String.speedyLabel
        speedLabel.textColor = UIColor.speedyColor
        timerLabel.textColor = UIColor.speedyColor
    }
    
    func setSpeedLabelSlow() {
        speedLabel.text = String.slowlyLabel
        speedLabel.textColor = UIColor.slowlyColor
        timerLabel.textColor = UIColor.slowlyColor
    }
    
    func updateWalkingImage(name: String) {
        walkingImage.image = UIImage(named: name)
    }
}

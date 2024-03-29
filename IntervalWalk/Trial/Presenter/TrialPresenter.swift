//
//  TrialPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import Foundation
import AVFoundation

protocol TrialPresenterInput {
    var state: State { get }
    var timerLabel: String { get }
    var player: AVAudioPlayer? { get }
    var hour: Int { get }
    var minute: Int { get }
    var second: Int { get }
    var userId: String { get }
    func showErrorAlert(error: NSError?)
    func getStartButtonTitle() -> String
    func setTimerLabelUpdated()
    func setStateChanged()
    func reset()
    func playStartSound()
}

protocol TrialPresenterOutput {
    func showErrorAlert(code: String, message: String)
    func updateTimerLabel()
    func updateWalkingImage(name: String)
    func setSpeedLabelSpeedy()
    func setSpeedLabelSlow()
}


final class TrialPresenter {
    private var _state: State
    var state: State {
        get {
            return _state
        }
    }
    
    private var _timerLabel: String
    var timerLabel: String {
        get {
            return _timerLabel
        }
    }
    
    private var _player: AVAudioPlayer?
    var player: AVAudioPlayer? {
        get {
            return _player
        }
    }
    
    private var _hour: Int
    var hour: Int {
        get {
            return _hour
        }
    }
    
    private var _minute: Int
    var minute: Int {
        get {
            return _minute
        }
    }
    
    private var _second: Int
    var second: Int {
        get {
            return _second
        }
    }
    
    private var _userId: String
    var userId: String {
        get {
            return _userId
        }
    }
    
    private var output: TrialPresenterOutput!
    init(output: TrialPresenterOutput) {
        self._state = .idle
        self._timerLabel = String.defaultTimerLabel
        self._hour = 0
        self._minute = 0
        self._second = 0
        
        let userId = AuthService.shared.getCurrentUserId()
        self._userId = userId ?? ""
        
        self.output = output
    }
    
    private func scheduleTimer() -> Timer {
        Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true,
            block: { [weak self] _ in
                self?.output.updateTimerLabel()
            }
        )
    }
    
    private func playSound(name: String) {
        guard let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return
        }
        do {
            _player = try AVAudioPlayer(contentsOf: soundURL)
            _player?.play()
        } catch let error as NSError {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
        }
    }
}

extension TrialPresenter: TrialPresenterInput {
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
    
    func getStartButtonTitle() -> String {
        switch state {
        case .idle, .pause:
            return String.startButtonLabel
        case .running:
            return String.stopButtonLabel
        }
    }
    
    func setTimerLabelUpdated() {
        let elapsedTime = state.elapsedTime(now: Date())
        let fixedElapsedTime = floor(Double(elapsedTime))
        
        _hour = Int(elapsedTime) / 3600
        _minute = Int(elapsedTime) / 60
        _second = Int(elapsedTime) % 60
        
        if (minute + 1) % 6 == 0 && second == 54 {
            playSound(name: "slow")
        } else if (minute + 1) % 3 == 0 && second == 54 {
            playSound(name: "speedy")
        }
        
        if minute != 0 && minute % 6 == 0 && second == 0 {
            output.setSpeedLabelSlow()
            output.updateWalkingImage(name: "slow")
        } else if minute != 0 && minute % 3 == 0 && second == 0 {
            output.setSpeedLabelSpeedy()
            output.updateWalkingImage(name: "speedy")
        }
        
        _timerLabel = String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    
    func setStateChanged() {
        switch state {
        case .idle:
            let runningState = RunningStateModel(
                elapsedTime: 0,
                timer: scheduleTimer()
            )
            _state = .running(runningState)
            
        case let .running(runningState):
            runningState.timer.invalidate()
            _state = .pause(
                PauseStateModel(
                    elapsedTime: runningState.elapsedTime + Date().timeIntervalSince(runningState.startDate)
                )
            )
            
        case let .pause(pauseState):
            _state = .running(
                RunningStateModel(
                    elapsedTime: pauseState.elapsedTime,
                    timer: scheduleTimer()
                )
            )
        }
    }
    
    func reset() {
        switch state {
        case .idle:
            Router.shared.showReStart()
        case let .running(runningState):
            runningState.timer.invalidate()
            _state = .idle
            Router.shared.showReStart()
        case .pause:
            _state = .idle
            Router.shared.showReStart()
        }
    }
    
    func playStartSound() {
        switch state {
        case .idle, .pause:
            playSound(name: "start")
        case .running:
            break
        }
    }
}

//
//  StopwatchPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/23.
//

import Foundation
import AVFoundation

protocol StopwatchPresenterInput {
    var state: State { get }
    var timerLabel: String { get }
    var player: AVAudioPlayer? { get }
    func showErrorAlert(error: NSError?)
    func getStartButtonTitle() -> String
    func setTimerLabelUpdated()
    func setStateChanged()
    func reset()
    func playStartSound()
}

protocol StopwatchPresenterOutput {
    func showErrorAlert(code: String, message: String)
    func updateTimerLabel()
    func updateWalkingImage(name: String)
    func setSpeedLabelSpeedy()
    func setSpeedLabelSlow()
}


final class StopwatchPresenter {
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
    
    private var output: StopwatchPresenterOutput!
    init(output: StopwatchPresenterOutput) {
        self._state = .idle
        self._timerLabel = "00:00:00"
        self.output = output
    }
    
    private func scheduleTimer() -> Timer {
        Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true,
            block: { [weak self] _ in
                print("block")
                self?.output.updateTimerLabel()
            }
        )
    }
    
    private func playSound(name: String) {
        guard let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("音声読み込めない")
            return
        }
        do {
            _player = try AVAudioPlayer(contentsOf: soundURL)
            _player?.play()
        } catch let error as NSError {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            print("error")
        }
    }
}

extension StopwatchPresenter: StopwatchPresenterInput {
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
    
    func getStartButtonTitle() -> String {
        switch state {
        case .idle, .pause:
            return "開始"
        case .running:
            return "停止"
        }
    }
    
    func setTimerLabelUpdated() {
        let elapsedTime = state.elapsedTime(now: Date())
        let fixedElapsedTime = floor(Double(elapsedTime))
        
        let hour = Int(elapsedTime) / 3600
        let minute = Int(elapsedTime) / 60
        let second = Int(elapsedTime) % 60
        
        print(fixedElapsedTime)
        print(hour, minute, second)
        
        if (minute + 1) % 6 == 0 && second == 54 {
            print("ゆっくりに切り替える")
            playSound(name: "slow")
        } else if (minute + 1) % 3 == 0 && second == 54 {
            print("早歩きに切り替える")
            playSound(name: "speedy")
        }
        
        if minute != 0 && minute % 6 == 0 && second == 0 {
            output.setSpeedLabelSlow()
            output.updateWalkingImage(name: "slow")
            print("ゆっくりに切り替える")
        } else if minute != 0 && minute % 3 == 0 && second == 0 {
            output.setSpeedLabelSpeedy()
            output.updateWalkingImage(name: "speedy")
            print("早歩きに切り替える")
        }
        print(elapsedTime)
        
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
            print("Timerを止める")
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
            break
        case let .running(runningState):
            runningState.timer.invalidate()
            _state = .idle
        case .pause:
            _state = .idle
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

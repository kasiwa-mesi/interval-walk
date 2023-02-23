//
//  StopwatchPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/23.
//

import Foundation

protocol StopwatchPresenterInput {
    var state: State { get }
    var timerLabel: String { get }
    func showErrorAlert(error: NSError?)
    func getStartButtonTitle() -> String
    func setTimerLabelUpdated()
    func setStateChanged()
    func reset()
}

protocol StopwatchPresenterOutput {
    func showErrorAlert(code: String, message: String)
    func updateTimerLabel()
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
        
        let hour = Int(elapsedTime) / 3600
        let minute = Int(elapsedTime) / 60
        let second = Int(elapsedTime) % 60
        
        print(hour, minute, second)
        
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
}

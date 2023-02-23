//
//  StateModel.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/23.
//

import Foundation

enum State {
    case idle
    case running(RunningStateModel)
    case pause(PauseStateModel)
    
    func elapsedTime(now: Date) -> TimeInterval {
        switch self {
        case .idle:
            return 0
        case let .running(state):
            return state.elapsedTime + now.timeIntervalSince(state.startDate)
        case let .pause(state):
            return state.elapsedTime
        }
    }
}

//
//  FLTimerProtocol.swift
//  Freelancer
//
//  Created by Nikola on 2/5/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Foundation

protocol FLTimerProtocol {
    func timeElapsedOnTimer(_ timer: FLTimer, timeElapsed: TimeInterval)
    func timerHasFinished(_ timer: FLTimer)
}

class FLTimer {
    
    var timer: Timer? = nil
    var startTime: Date?
    var elapsedTime: TimeInterval = 0
    
    var isStopped: Bool {
        return timer == nil && elapsedTime == -1
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    var delegate: FLTimerProtocol?
    
    @objc dynamic func timerAction() {
        guard let startTime = startTime else {
            return
        }
        
        elapsedTime = -1 * startTime.timeIntervalSinceNow
        let secondsElapsed = elapsedTime.rounded()
        
        if secondsElapsed == -1 {
            stopTimer()
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeElapsedOnTimer(self, timeElapsed: secondsElapsed)
        }
        NotificationCenter.default.post(name: .hoursUpdated, object: nil)
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        timerAction()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        elapsedTime = -1
        
        timerAction()
    }
    
}


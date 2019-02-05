//
//  TimerController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa

class TimerController: NSViewController {
    
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnEnd: NSButton!
    @IBOutlet weak var txtTime: NSTextField!
    
    var flTimer = FLTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flTimer.delegate = self
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func timerStart(_ sender: Any?) {
        flTimer.startTimer()
       
        btnStart.isEnabled = false
        btnEnd.isEnabled = true
    }
    
    @IBAction func timerStop(_ sender: Any?) {
        let stop = dialogOKCancel(question: "Stop the timer?", text: "Stopping the timer will add currently worked hours to today's time sheet 📆", btnTrue: "Yes", btnFalse: "Continue working")
        if stop {
            flTimer.stopTimer()
            btnStart.isEnabled = true
            btnEnd.isEnabled = false
        }
    }
    
    func dialogOKCancel(question: String, text: String, btnTrue: String, btnFalse: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: btnTrue)
        alert.addButton(withTitle: btnFalse)
        return alert.runModal() == .alertFirstButtonReturn
    }

}

extension TimerController {
    func updateDisplay(for timeElapsed: TimeInterval) {
        txtTime.stringValue = textToDisplay(for: timeElapsed)
    }
    
    private func textToDisplay(for timeElapsed: TimeInterval) -> String {
        if timeElapsed == -1 {
            return "Done!"
        }
        
        let (h, m, s) = secondsToTime(seconds: Int(timeElapsed))
        let timeElapsedDisplay = "\(String(format: "%02d", h)):\(String(format: "%02d", m)):\(String(format: "%02d", s))"
        return timeElapsedDisplay
    }
    
    // Parses seconds to hours, minutes and seconds
    private func secondsToTime( seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

extension TimerController: FLTimerProtocol {
    func timeElapsedOnTimer(_ timer: FLTimer, timeElapsed: TimeInterval) {
        updateDisplay(for: timeElapsed)
    }
    
    func timerHasFinished(_ timer: FLTimer) {
        updateDisplay(for: 0)
    }
}

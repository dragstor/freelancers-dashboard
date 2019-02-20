//
//  TimerController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa
import SQLite
import SwiftDate

class TimerController: NSViewController {
    
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnEnd: NSButton!
    @IBOutlet weak var txtTime: NSTextField!
    
    var flTimer = FLTimer()
    
    var t_from: TimeInterval?
    var t_to: TimeInterval?
    var t_total: TimeInterval?
    
    let ts_date         = Expression<TimeInterval>("ts_date")
    let ts_from         = Expression<TimeInterval>("ts_from")
    let ts_to           = Expression<TimeInterval>("ts_to")
    let ts_total_time   = Expression<TimeInterval>("ts_total_time")
    let ts_approved     = Expression<Bool>("ts_approved")
    
    let db = try? Connection("\(NSApp.supportFolderGet())/db.sqlite3")
    
    let tableTimesheets = Table("timesheets_interval")
    
    let fmt = DateFormatter()
    let format = "yyyy-MM-dd HH:mm:ss"
    let formatSec = "HH:mm:ss"
    let bgd = Region.current
    
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
       
        fmt.dateFormat = format
        t_from = DateInRegion().timeIntervalSince1970
        
        btnStart.isEnabled = false
        btnEnd.isEnabled = true
    }
    
    @IBAction func timerStop(_ sender: Any?) {
        let stop = dialogOKCancel(question: "Stop the timer?", text: "Stopping the timer will add currently worked time to today's time sheet.", btnTrue: "Yes", btnFalse: "Continue working")
        if stop {
            fmt.dateFormat = format

            t_to = DateInRegion().timeIntervalSince1970

            flTimer.stopTimer()

            t_total = txtTime.stringValue.toDate()?.timeIntervalSince1970
            
            fmt.dateFormat = formatSec
            let total = Date(seconds: t_to!).timeIntervalSince(Date(seconds: t_from!))
            t_total = total
            
            do {
                fmt.dateFormat = format
                try db?.run(
                    tableTimesheets.insert(
                        ts_date <- t_from!,
                        ts_from <- t_from!,
                        ts_to <- t_to!,
                        ts_total_time <- t_total!,
                        ts_approved <- false
                    )
                )
            } catch let Result.error(message, code, statement) where code == SQLITE_ANY {
                NSAlert.showAlert(title: "\(message)", message: "Error with statement: \(String(describing: statement))")
            } catch let error {
                NSAlert.showAlert(title: "ERROR", message: "\(error)")
            }
        
            txtTime.stringValue = "00:00:00"
            
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
            return "00:00:00"
        }
        
        let (h, m, s) = secondsToTime(seconds: Int(timeElapsed))
        let timeElapsedDisplay = "\(String(format: "%02d", h)):\(String(format: "%02d", m)):\(String(format: "%02d", s))"
        return timeElapsedDisplay
    }
    
    // 
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

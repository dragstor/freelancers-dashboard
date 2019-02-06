//
//  TimerController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa
import SQLite

class TimerController: NSViewController {
    
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnEnd: NSButton!
    @IBOutlet weak var txtTime: NSTextField!
    
    var flTimer = FLTimer()
    
    var t_from: String?    = nil
    var t_to: String?      = nil
    var t_total: String?   = nil
    
    let ts_date         = Expression<String>("ts_date")
    let ts_from         = Expression<String>("ts_from")
    let ts_to           = Expression<String>("ts_to")
    let ts_total_time   = Expression<String>("ts_total_time")
    let ts_approved     = Expression<Int64>("ts_approved")
    
    let db = try? Connection("\(NSHomeDirectory())/db.sqlite3")
    let tableTimesheets = Table("timesheets")
    
    let fmt = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        fmt.dateStyle = .long
//        fmt.timeStyle = .medium
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"

        flTimer.delegate = self
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func timerStart(_ sender: Any?) {
        flTimer.startTimer()
       
        t_from = fmt.string(from: Date())
        
        btnStart.isEnabled = false
        btnEnd.isEnabled = true
    }
    
    @IBAction func timerStop(_ sender: Any?) {
        let stop = dialogOKCancel(question: "Stop the timer?", text: "Stopping the timer will add currently worked hours to today's time sheet 📆", btnTrue: "Yes", btnFalse: "Continue working")
        if stop {
            flTimer.stopTimer()
            
            t_to = fmt.string(from: Date())
            t_total = txtTime.stringValue
            
            do {
                let rowid = try db?.run(
                    tableTimesheets.insert(
                        ts_date <- t_from!,
                        ts_from <- t_from!,
                        ts_to <- t_to!,
                        ts_total_time <- t_total!,
                        ts_approved <- 0
                    )
                )
                print("inserted id: \(String(describing: rowid))")
            } catch {
                print("insertion failed: \(error)")
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

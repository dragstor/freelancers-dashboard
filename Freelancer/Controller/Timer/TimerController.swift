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

class TimerController: NSViewController, NSApplicationDelegate {
    
    @IBOutlet weak var vev: NSVisualEffectView!
    @IBOutlet var timerWindow: NSView!
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnEnd: NSButton!
    @IBOutlet weak var txtTime: NSTextField!
    @IBOutlet weak var progress: NSLevelIndicator!
    @IBOutlet weak var lblProgressValue: NSTextField!
    
    var flTimer = FLTimer()
    
    var prefs = Preferences()
    
    var t_from: TimeInterval = 0
    var t_to: TimeInterval = 0
    var t_total: TimeInterval = 0
    
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
    
    var em: EventMonitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flTimer.delegate = self
        _ = getRemainingTime(time: 0)
        vev?.blendingMode = .behindWindow

        self.view.window?.hasShadow = true
        
//        if #available(OSX 10.14, *) {
//             .material = .
//        } else {
//            // Fallback on earlier versions
//            vev.material = .appearanceBased
//        }
    }
    override func viewDidAppear() {
        self.view.window?.isOpaque = false
        self.view.window?.backgroundColor = .clear
    }
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
            if self.view.isHidden == true {
                _ = getRemainingTime(time: 0)
            }
        }
    }
    
    @IBAction func timerStart(_ sender: Any?) {
//        let n  = NSUserNotification()
//        let nc = NSUserNotificationCenter.default


        flTimer.startTimer()

        fmt.dateFormat = format
        t_from = DateInRegion().timeIntervalSince1970

        btnStart.isEnabled = false
        btnEnd.isEnabled = true

        self.view.window?.close()

//        n.title = "Time Logger"
//        n.informativeText = "Timer has started logging the time."
//
//        n.hasActionButton = true
//
//        n.actionButtonTitle = "Stop the timer?"
//        n.otherButtonTitle  = "👍"
//
//        nc.scheduleNotification(n)
        

        let viewController:NSViewController = NSStoryboard(name: "Notification", bundle: nil).instantiateController(withIdentifier: "notificationSB") as! NSViewController
        
        self.presentAsModalWindow(viewController)
    }

    @IBAction func timerStop(_ sender: Any?) {
        stopTimer()
    }
    
    func stopTimer(stopNow: Bool = false) {
        if stopNow == true {
            storeTime()
        } else {
            let ask = askToStop()
            if ask == true {
                storeTime()
            }
        }
        
    }
    
    func askToStop()-> Bool {
        let stop = dialogOKCancel(question: "Stop the timer?", text: "Stopping the timer will add currently worked time to today's time sheet.", btnTrue: "Yes", btnFalse: "Continue working")
        
        return stop
    }
    
    func storeTime() {
        fmt.dateFormat = format
        
        t_to = DateInRegion().timeIntervalSince1970
        
        flTimer.stopTimer()
        
        t_total = txtTime.stringValue.toDate()!.timeIntervalSince1970
        
        print("From \(t_from) -  To \(t_to)")
        
        fmt.dateFormat = formatSec
        if t_from == 0 {
            return
        } else {
            let total = Date(seconds: t_to).timeIntervalSince(Date(seconds: t_from))
            t_total = total

            do {
                fmt.dateFormat = format
                try db?.run(
                    tableTimesheets.insert(
                        ts_date <- t_from,
                        ts_from <- t_from,
                        ts_to <- t_to,
                        ts_total_time <- t_total,
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
        txtTime.stringValue   = textToDisplay(for: timeElapsed)
        let rt = getRemainingTime(time: timeElapsed)
        if rt ~= 0 {
            storeTime()
            NSAlert.showAlert(title: "Time's up!", message: "You've reached maximum billable hours for this week.", style: .warning)
        }
        
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
    
    func getRemainingTime(time: TimeInterval) -> Int {
        let maxHr:TimeInterval     = TimeInterval(Int(prefs.maxWeeklyHours) * 3600)
        let weekHr:TimeInterval    = prefs.weekHours // 3600
        var currentHr:TimeInterval = 0
        currentHr = maxHr - weekHr - time
        
        if currentHr <= 0 {
            NSAlert.showAlert(title: "Warning", message: "You don't have any billable hours available for this week!\n\nTime logging has been stopped and your hours have been logged.\n\nIf you need to continue working whatsoever, please increase maximum billable hours in the Preferences.", style: .warning)
            btnStart.isEnabled = false
            btnEnd.isEnabled = false
            stopTimer(stopNow: true)
            
            return 0
        } else {
            let tStr = currentHr.toString()
            let pMax = Double(maxHr / 360)
            
            progress.maxValue = pMax
            progress.warningValue = pMax * 7 * 0.1
            progress.criticalValue = pMax * 9 * 0.1
            
            progress.doubleValue = (weekHr + time) / 360
            
            lblProgressValue.stringValue = "Remaining billable time: \(tStr)"

            return Int(currentHr)
        }
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

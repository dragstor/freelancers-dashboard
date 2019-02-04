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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func timerStart(_ sender: Any?) {
        btnStart.isEnabled = false
        btnEnd.isEnabled = true
    }
    
    @IBAction func timerStop(_ sender: Any?) {
        let stop = dialogOKCancel(question: "Stop the timer?", text: "Stopping the timer will add currently worked hours to today's time sheet.", btnTrue: "Yes", btnFalse: "Continue working")
        if stop {
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

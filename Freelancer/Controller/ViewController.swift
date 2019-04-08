//
//  ViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var progress: NSLevelIndicator!
    @IBOutlet weak var lblTimerRunningStatus: NSTextField!
    @IBOutlet weak var btnToday: NSButton!
    @IBOutlet weak var btnWeekly: NSButton!
    @IBOutlet weak var btnEarnings: NSButton!
    @IBOutlet weak var btnPreferences: NSButton!
    var prefs = Preferences()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getWorkedTime()
        onBoarding()
        
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
            
            getWorkedTime()
        }
    }
    
    override func viewDidAppear() {
        let mwh = prefs.maxWeeklyHours
        let rph = prefs.ratePerHour
        
        if mwh != 0 && rph != 0.0 {
            btnToday.isEnabled = true
            btnWeekly.isEnabled = true
            btnEarnings.isEnabled = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(notification:)), name: .hoursUpdated, object: nil)
        
    }
    
    
    @objc func onDidReceiveData(notification:Notification) {
        getWorkedTime()
    }

    func getWorkedTime() {
        let maxHr:TimeInterval     = TimeInterval(Int(prefs.maxWeeklyHours) * 3600)
        let weekHr:TimeInterval    = prefs.weekHours // 3600
        
        let pMax = Double(maxHr / 360)
        
        progress.maxValue = pMax
        progress.warningValue = pMax * 7 * 0.1
        progress.criticalValue = pMax * 9 * 0.1
        
        progress.doubleValue = weekHr / 360
//        print("Vrednost notifikacija: \(weekHr)")
    }
    
    func onBoarding() {
        let firstRun: Bool = prefs.firstRun
//        goToScreen(id: "onboarding", fromBoard: "OnBoarding")
        if firstRun == true {
            let viewController:NSViewController = NSStoryboard(name: "OnBoarding", bundle: nil).instantiateController(withIdentifier: "onboarding") as! NSViewController
            presentAsModalWindow(viewController)
            
            let preferencesController:NSViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "preferences") as! NSViewController
            presentAsModalWindow(preferencesController)
            
            btnToday.isEnabled = false
            btnWeekly.isEnabled = false
            btnEarnings.isEnabled = false
        } else {
            btnToday.isEnabled = true
            btnWeekly.isEnabled = true
            btnEarnings.isEnabled = true
        }
    }

}


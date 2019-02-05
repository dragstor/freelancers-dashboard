//
//  GeneralPreferenceViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa
import LaunchAtLogin

class GeneralPreferencesViewController: NSViewController {
    @IBOutlet weak var autoStart: NSButton!
    
    @IBOutlet weak var txtHours: NSTextField!
    @IBOutlet weak var txtRPH: NSTextField!
    
    @IBOutlet weak var btnCancel: NSButton!
    @IBOutlet weak var btnSave: NSButton!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showExistingPrefs()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func showExistingPrefs() {
        let autoStartApp = Bool(prefs.autoStart)
        let hrs = Int16(prefs.maxWeeklyHours)
        let rph = Double(prefs.ratePerHour)
        
        if autoStartApp == true {
            // Autostart functionality and check the checkbutton
            autoStart.state = .on
        }
        
        txtHours.stringValue = String(hrs)
        txtRPH.stringValue = String(rph)
        
    }
    
    func saveExistingPrefs() {
        if autoStart.state == .on {
            prefs.autoStart = true
            LaunchAtLogin.isEnabled = true
        } else {
            prefs.autoStart = false
            LaunchAtLogin.isEnabled = false
        }
        prefs.maxWeeklyHours = Int16(txtHours.stringValue)!
        prefs.ratePerHour = Double(txtRPH.stringValue)!
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"), object: nil)
    }
    
    @IBAction func btnSave(_ sender: NSButton!) {
        saveExistingPrefs()
        super.view.window?.close()
    }
    
    @IBAction func btnCancel(_ sender: NSButton!) {
        super.view.window?.close()
    }
    
    
}

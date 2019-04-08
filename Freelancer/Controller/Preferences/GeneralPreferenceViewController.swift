//
//  GeneralPreferenceViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa
//import LaunchAtLogin

class GeneralPreferencesViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var autoStart: NSButton!
    
    @IBOutlet weak var txtHours: NSTextField!
    @IBOutlet weak var txtRPH: NSTextField!
    @IBOutlet weak var currency: NSPopUpButton!
    
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
        currency.selectItem(at: prefs.currency)
        
    }
    
    func saveExistingPrefs() {
        let rph = txtRPH.stringValue
        let mwh = txtHours.stringValue
        let cur = currency.indexOfSelectedItem
        
        if autoStart.state == .on {
            prefs.autoStart = true
//            LaunchAtLogin.isEnabled = true
        } else {
            prefs.autoStart = false
//            LaunchAtLogin.isEnabled = false
        }
        prefs.maxWeeklyHours = Int16(mwh)!
        prefs.ratePerHour = Double(rph)!
        prefs.currency = cur
        
        if rph != "0.0" && mwh != "0" {
            prefs.firstRun = false
        }
        
    }
    

    
    @IBAction func btnSave(_ sender: NSButton!) {
        let rph = txtRPH.stringValue
        let mwh = txtHours.stringValue
        
        if rph == "0.0" || rph == "" || mwh == "0" || mwh == ""  {
            NSAlert.showAlert(title: "ERROR", message: "You must enter valid data!", style: .warning)
        } else {
            saveExistingPrefs()
            super.view.window?.close()
        }
    }
    
    @IBAction func btnCancel(_ sender: NSButton!) {
        let rph = txtRPH.stringValue
        let mwh = txtHours.stringValue
        
        if rph == "0.0" || rph == "" || mwh == "0" || mwh == ""  {
            NSAlert.showAlert(title: "ERROR", message: "You must enter valid data!", style: .warning)
        } else {
            super.view.window?.close()
        }
    }
    
    
}
extension ViewController: NSControlTextEditingDelegate {
    func controlTextDidChange(_ notification: Notification) {
        if let textField = notification.object as? NSTextField {
            print(textField.stringValue)
            //do what you need here
        }
    }
}

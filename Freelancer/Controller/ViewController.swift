//
//  ViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var lblTimerRunningStatus: NSTextField!
    var prefs = Preferences()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Week Hours: \(prefs.weekHours)")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


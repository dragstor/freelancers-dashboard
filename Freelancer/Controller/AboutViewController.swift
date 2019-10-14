//
//  AboutViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/5/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    @IBOutlet weak var lblVersion: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let version = Bundle.main.versionNumber
        let build   = Bundle.main.buildNumber
        lblVersion.stringValue = "version \(version) (Build \(build))"
    }
}

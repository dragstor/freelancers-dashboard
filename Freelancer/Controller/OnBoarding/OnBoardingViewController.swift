//
//  OnBoardingViewController.swift
//  Freelancer
//
//  Created by Nikola on 3/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa

class OnBoardingViewController: NSViewController {

    @IBOutlet weak var onboardingView: NSView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if self.view.isDarkMode == true {
            self.view.window?.appearance = NSAppearance(named: .vibrantDark)
        } else {
            self.view.window?.appearance = NSAppearance(named: .vibrantLight)
        }
    }
    
    override func viewDidAppear() {
        self.view.window?.styleMask.remove([.closable,.miniaturizable,.resizable,.titled])
//        self.view.window?.styleMask.insert(.unifiedTitleAndToolbar)
        
//        let customToolbar = NSToolbar()

        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.titleVisibility = .hidden
        
//        self.view.window?.toolbar = customToolbar
        
    }
    
    
    @IBAction func close(_ sender: Any?) {
        self.view.window?.close()
    }
}

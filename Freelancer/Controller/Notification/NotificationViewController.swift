//
//  ViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa
import Foundation


class NotificationViewController: NSViewController {
    
    
    
    @IBOutlet weak var notificationView: NSView!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var message: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let when = DispatchTime.now()// + 3
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            self.view.window?.fadeOut(sender: self, duration: 5, timingFunction: nil, targetAlpha: 0.0, resetAlphaAfterAnimation: false, closeSelector: .performClose, completionHandler: self.view.window?.close)
        })
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        
        // Customize the notification alert
        let visualEffect = NSVisualEffectView()
        
        // Adjust the icon color to the currently set appearance (dark/light)
        if self.view.isDarkMode == true {
            image.contentFilters.append(CIFilter.init(name: "CIColorInvert")!)
            self.view.window?.appearance = NSAppearance(named: .vibrantDark)
        } else {
            image.contentFilters.removeAll()
            self.view.window?.appearance = NSAppearance(named: .vibrantLight)
        }
        
        
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
//        visualEffect.material = .appearanceBased
        visualEffect.state = .active
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 16.0
        
        
        self.view.window?.titleVisibility = .hidden
        self.view.window?.styleMask.remove(.titled)
        self.view.window?.styleMask.remove(.resizable)
        
        self.view.window?.backgroundColor = .clear
        self.view.window?.isMovableByWindowBackground = false
        
        
        self.view.window?.contentView?.addSubview(visualEffect)
        self.view.window?.contentView?.addSubview(notificationView)
        
        guard let constraints = self.view.window?.contentView else {
            return
        }
        
        visualEffect.leadingAnchor.constraint(equalTo: constraints.leadingAnchor).isActive = true
        visualEffect.trailingAnchor.constraint(equalTo: constraints.trailingAnchor).isActive = true
        visualEffect.topAnchor.constraint(equalTo: constraints.topAnchor).isActive = true
        visualEffect.bottomAnchor.constraint(equalTo: constraints.bottomAnchor).isActive = true
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}


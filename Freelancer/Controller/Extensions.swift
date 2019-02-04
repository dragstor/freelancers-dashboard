//
//  Extensions.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa

extension ViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> TimerController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Timer"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("TimerScene")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TimerController else {
            fatalError("Why cant i find PopoverTimer? - Check Timer.storyboard")
        }
        return viewcontroller
    }
}


extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}

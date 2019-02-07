//
//  Extensions.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa

extension TimerController {
    // MARK: Storyboard instantiation
    static func freshController() -> TimerController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Timer"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("TimerScene")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TimerController else {
            fatalError("Why cant i find Timer popover? - Check Timer.storyboard")
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

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    func toString(withFormat format: String = "HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let strMonth = dateFormatter.string(from: self)
        
        return strMonth
    }
    
    func getDay(withFormat format: String = "EEEE, d MMM yyyy")-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let day = dateFormatter.string(from: self)
        return day
    }
}


extension String {
    
    func toTime(withFormat format: String = "yyyy-mm-dd HH:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
    
    func getDay(withFormat format: String = "yyyy-mm-dd")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        let day = dateFormatter.date(from: self)
        
        return day
    }
}

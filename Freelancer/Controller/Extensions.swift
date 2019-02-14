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
    
    func getDay(withFormat format: String = "EEEE, d MMM yyyy")-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        let day = dateFormatter.string(from: self)
        return day
    }
    
    func getTime(withFormat format: String = "HH:mm:ss")-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        let time = dateFormatter.string(from: self)
        return time
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}


extension String {
    
//    func toTime(withFormat format: String = "yyyy-mm-dd HH:mm:ss")-> Date?{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        let date = dateFormatter.date(from: self)
//        
//        return date
//        
//    }
    
    func getDay(withFormat format: String = "yyyy-mm-dd")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        let day = dateFormatter.date(from: self)
        
        return day
    }
    
    func getEarnings()-> String {
        var earnings: Double = 0.0
        var prefs = Preferences()
        let rph = prefs.ratePerHour
        
        if let time = Date(self) {
            let h = time.hour * 60
            let m = time.minute
            
            if h == 0 && m == 0 {
                earnings = 0.0
            } else {
                let tmp = h + m
                earnings = Double(tmp) * (rph/100)
            }
        }
        return String(format:"$%.2f", earnings)
    }
}

extension NSApplication {
    func supportFolderGet()-> String {
        let path = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory, .userDomainMask, true
            ).first! + "/" + Bundle.main.bundleIdentifier!
        
        return path
    }
}

extension NSAlert {
    static func showAlert(title: String?, message: String?, style: NSAlert.Style = .informational) {
        let alert = NSAlert()
        if let title = title {
            alert.messageText = title
        }
        if let message = message {
            alert.informativeText = message
        }
        alert.alertStyle = style
        alert.runModal()
    }
}







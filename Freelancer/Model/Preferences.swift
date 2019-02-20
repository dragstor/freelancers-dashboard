//
//  Preferences.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//
import Cocoa

struct Preferences {
    var autoStart: Bool {
        get {
            let savedAutoStart = UserDefaults.standard.bool(forKey: "autoStart")
            if savedAutoStart == true {
                return true
            }
            
            return false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autoStart")
        }
    }
    
    var maxWeeklyHours: Int16 {
        get {
            let maxWHours = UserDefaults.standard.integer(forKey: "maxWeeklyHours")
            if maxWHours > 0 {
                return Int16(maxWHours)
            }
            
            return 0
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "maxWeeklyHours")
        }
    }
    
    var ratePerHour: Double {
        get {
            let ratePH = UserDefaults.standard.double(forKey: "ratePerHour")
            
            if ratePH != 0.00 {
                return Double(ratePH)
            }
            
            return 0.00
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "ratePerHour")
        }
    }
    
    var weekHours: TimeInterval {
        get {
            let weekHours = UserDefaults.standard.double(forKey: "weekHours")
            
            if weekHours != 0.0 {
                return TimeInterval(weekHours)
            }
            
            return 0.0
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "weekHours")
        }
    }
    
    var weekEarnings: Double {
        get {
            let weekEarnings = UserDefaults.standard.double(forKey: "weekEarnings")
            
            if weekEarnings != 0.0 {
                return Double(weekEarnings)
            }
            
            return 0.0
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "weekEarnings")
        }
    }
}

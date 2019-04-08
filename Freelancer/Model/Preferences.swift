//
//  Preferences.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//
import Cocoa

/// Preferences struct
///   Used to set and get params important to the appß
struct Preferences {
    /// Defines if the app will auto start with the system boot (user login)
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
    
    /// Used to determine if the onboarding screen will appear
    var firstRun: Bool {
        get {
            let isFirstRun = UserDefaults.standard.bool(forKey: "firstRun")
            if isFirstRun == true {
                return true
            }
            
            return false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "firstRun")
        }
    }
    
    /// Freelancer's maximum weekly billable hours
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
    
    
    /// Freelancer's per hour rate
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
    
    /// Worked hours this week
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
    
    /// Earnings for current week
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
    
    var currency: Int {
        get {
            let currency = UserDefaults.standard.integer(forKey: "currency")
            
            return currency
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "currency")
        }
    }
}

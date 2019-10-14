//
//  Preferences.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//
import Cocoa

struct Preferences {
    private let defaults = UserDefaults.standard
    
    private struct KeyNames {
        static let autoStart = "autoStart"
        static let maxHoursKey = "maxWeeklyHours"
        static let rateKey = "ratePerHour"
        static let ratePerHour = "ratePerHour"
        static let weekKeys = "weekHours"
        static let weekEarnings = "weekEarnings"
    }
    
    var autoStart: Bool {
        get {
            defaults.bool(forKey: KeyNames.autoStart)
        }
        set {
            defaults.set(newValue, forKey: KeyNames.autoStart)
        }
    }
    
    var maxWeeklyHours: Int16 {
        get {
            let value = defaults.integer(forKey: KeyNames.maxHoursKey)
            if value > 0 {
                return Int16(value)
            }
            
            return 0
        }
        
        set {
            defaults.set(newValue, forKey: KeyNames.maxHoursKey)
        }
    }
    
    var ratePerHour: Double {
        get {
            let ratePH = defaults.double(forKey: KeyNames.ratePerHour)
            
            if ratePH != 0.00 {
                return Double(ratePH)
            }
            
            return 0.00
        }
        
        set {
            defaults.set(newValue, forKey: KeyNames.ratePerHour)
        }
    }
    
    var weekHours: TimeInterval {
        get {
            let weekHours = defaults.double(forKey: KeyNames.weekKeys)
            
            if weekHours != 0.0 {
                return TimeInterval(weekHours)
            }
            
            return 0.0
        }
        
        set {
            defaults.set(newValue, forKey: KeyNames.weekKeys)
        }
    }
    
    var weekEarnings: Double {
        get {
            let weekEarnings = defaults.double(forKey: KeyNames.weekEarnings)
            
            if weekEarnings != 0.0 {
                return Double(weekEarnings)
            }
            
            return 0.0
        }
        
        set {
            defaults.set(newValue, forKey: KeyNames.weekEarnings)
        }
    }
}

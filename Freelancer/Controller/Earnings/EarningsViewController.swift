//
//  EarningsViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/17/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Cocoa
import SQLite
import SwiftDate

class EarningsViewController: NSViewController {
    @IBOutlet weak var lblToday: NSTextField!
    @IBOutlet weak var lblWeek: NSTextField!
    @IBOutlet weak var lblAllTheTime: NSTextField!
    
    let ts_id           = Expression<TimeInterval>("id")
    let ts_date         = Expression<TimeInterval>("ts_date")
    let ts_from         = Expression<TimeInterval>("ts_from")
    let ts_to           = Expression<TimeInterval>("ts_to")
    let ts_total_time   = Expression<TimeInterval>("ts_total_time")
    
    let fmt             = DateFormatter()
    let format          = "yyyy-MM-dd HH:mm:ss"
    let formatSec       = "HH:mm:ss"
    let formatDay       = "EEEE"
    let formatWeekShort = "yyyy-MM-dd"
    let formatWeekLong  = "yyyy-MM-dd HH:mm:ss"
    
    var totalHours:TimeInterval    = 0
    var newTime:TimeInterval       = 0
    
    var todayTime:TimeInterval   = 0
    var weekTime:TimeInterval    = 0
    
    var totalHoursDay: TimeInterval  = 0
    var totalHoursWeek: TimeInterval = 0
    
    var days:[[String:String]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        SwiftDate.defaultRegion = Region.current
        

        
    }    
}

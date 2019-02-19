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
    
    let ts_date         = Expression<String>("ts_date")
    let ts_from         = Expression<String>("ts_from")
    let ts_to           = Expression<String>("ts_to")
    let ts_total_time   = Expression<String>("ts_total_time")
    
    let fmt             = DateFormatter()
    let format          = "yyyy-MM-dd HH:mm:ss"
    let formatSec       = "HH:mm:ss"
    let formatDay       = "EEEE"
    let formatWeekShort = "yyyy-MM-dd"
    let formatWeekLong  = "yyyy-MM-dd HH:mm:ss"
    
    var totalHours    = DateInRegion().dateAt(.startOfDay)
    var newTime       = DateInRegion().dateAt(.startOfDay)
    
    var todayTime   = ""
    var weekTime    = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        do {
            let db = try Connection("\( NSApp.supportFolderGet())/db.sqlite3")
            let tableTimesheets = Table("timesheets")
            
            let now = DateInRegion()
            let today_start = String(now.dateAtStartOf(.day).toFormat(format))
            let today_end   = String(now.dateAtEndOf(.day).toFormat(format))
            
            let query = tableTimesheets
                .select(ts_total_time)
                .filter(
                    today_start...today_end ~= ts_date
            )
            
            let today_timesheet = try db.prepare(query)
            
            for entry in today_timesheet {
                do {
                    fmt.dateFormat = formatSec
                    let date_total = entry[ts_total_time]
                    
                    todayTime = addTime(timeToAdd: date_total)
                    
                }
            }
            lblToday.stringValue = todayTime.getEarnings()
            lblWeek.stringValue = getWeeklyEearnings()
        } catch {
            NSAlert.showAlert(title: "Error loading timesheets", message: "Unable to load timesheet!", style: .critical)
        }
        
    }
    
    func addTime(timeToAdd: String, addToDay: String = "", dailyPrevious: String = "")-> String {
        let fmt = DateFormatter()
        fmt.dateStyle  = .none
        fmt.timeStyle  = .medium
        fmt.dateFormat = "HH:mm:ss"
        
        if let time = DateInRegion(timeToAdd) {
            let h         = time.hour
            let m         = time.minute
            let s         = time.second
            
            if addToDay.isEmpty {
                // Weekly calculation
                newTime = totalHours + h.hours + m.minutes + s.seconds
                totalHours = newTime

                weekTime = totalHours.toFormat("HH:mm:ss")

                return weekTime
            } else {
                // One day calculation
                weekTime = (DateInRegion(dailyPrevious)! + h.hours + m.minutes + s.seconds).toFormat(formatWeekLong)
                lblWeek.stringValue = weekTime
                return weekTime //.toFormat("HH:mm:ss")
            }
        } else {
            return ""
        }
    }
    
    func getWeeklyEearnings() -> String {
        var currentWeekStart = Date().dateAt(.startOfWeek)
        var currentWeekEnd   = Date().dateAt(.endOfWeek)
        var timePerDay = [String:(String)]()
        var earnings = ""
        
        do{
            let db = try Connection("\( NSApp.supportFolderGet())/db.sqlite3")
            let tableTimesheets = Table("timesheets")
            
            let dayStart = currentWeekStart.toFormat(formatWeekLong)
            let dayEnd   = currentWeekEnd.toFormat(formatWeekLong)
            
            let query = tableTimesheets
                .select(ts_date, ts_total_time)
                .filter(dayStart...dayEnd ~= ts_date)
                .order(ts_date)
            
            // debug
            //            print(query.asSQL())
            
            let weekTimesheet = try db.prepare(query)
            
            let dates = DateInRegion.enumerateDates(from: DateInRegion(currentWeekStart), to: DateInRegion(currentWeekEnd), increment: 1.days)
            
            var suma = "00:00:00"
            
            for entry in weekTimesheet {
                for weekDay in dates {
                    
                    let dateDay    = entry[ts_date]
                    let dateTotal  = entry[ts_total_time]
                    let addToDay   = weekDay.toFormat(formatSec)
                    var dayTotal   = timePerDay[weekDay.toFormat(formatDay)] ?? "00:00:00"
                    
                    if DateInRegion(dateDay)!.isInside(date: weekDay, granularity: .day) {
                        suma = addTime(timeToAdd: dateTotal, addToDay: addToDay, dailyPrevious: dayTotal)
                        timePerDay[weekDay.toFormat(formatDay)] = suma
                    }
                    
                    dayTotal = suma
                    
                }
            }
            
            for tsDay in dates {
                let dan = tsDay.toFormat(formatDay)
                
                
                for ts in timePerDay {
                    
                    if ts.key == dan {
                        earnings = ts.value.getEarnings()
                        _ = addTime(timeToAdd: ts.value)
                    }
                }
            }

//            lblWeek.stringValue = lblTotalHours.stringValue.getEarnings()
        } catch {
            NSAlert.showAlert(title: "ERROR", message: "Error with DB!", style: .critical)
        }
        return earnings
    }
    
}

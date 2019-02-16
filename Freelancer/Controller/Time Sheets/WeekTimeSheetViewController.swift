//
//  WeekTimeSheetViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Foundation
import Cocoa
import SwiftDate
import SQLite

class WeekTimeSheetViewController: NSViewController {
    
    @IBOutlet weak var currentWeek: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var lblCurrentWeek: NSTextField!
    @IBOutlet weak var CellDay: NSTableCellView!
    @IBOutlet weak var CellHours: NSTableCellView!
    @IBOutlet weak var CellEarned: NSTableCellView!
    
    @IBOutlet weak var lblTotalHours: NSTextField!
    @IBOutlet weak var lblTotalEarnings: NSTextField!
    
    var currentWeekStart = Date().dateAt(.startOfWeek)
    var currentWeekEnd   = Date().dateAt(.endOfWeek)
    
    let ts_id           = Expression<Int>("id")
    let ts_date         = Expression<String>("ts_date")
    let ts_total_time   = Expression<String>("ts_total_time")
    
    let fmt             = DateFormatter()
    let format          = "yyyy-MM-dd HH:mm:ss"
    let formatSec       = "HH:mm:ss"
    let formatDay       = "EEEE"
    let formatWeekShort = "yyyy-MM-dd"
    let formatWeekLong  = "yyyy-MM-dd HH:mm:ss"

    var totalHours    = DateInRegion().dateAt(.startOfDay)
    var newTime       = DateInRegion().dateAt(.startOfDay)
    
    var days:[[String:String]] = [[:]]
    var timePerDay = [String:(String)]()
    
    struct TS {
        let day: String
        
    }
    var dayTotalVar:String? = "00:00:00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblCurrentWeek.stringValue = "\(currentWeekStart.toFormat(formatWeekShort)) to \(currentWeekEnd.toFormat(formatWeekShort))"
        
        
        do{
            let db = try Connection("\( NSApp.supportFolderGet())/db.sqlite3")
            let tableTimesheets = Table("timesheets")
            
            let dayStart = currentWeekStart.toFormat(formatWeekLong)
            let dayEnd   = currentWeekEnd.toFormat(formatWeekLong)
            
            let query = tableTimesheets
                .select(ts_id, ts_date, ts_total_time)
                .filter(dayStart...dayEnd ~= ts_date)
                .order(ts_id)

            // debug
//            print(query.asSQL())
            
            let weekTimesheet = try db.prepare(query)

            let dates = DateInRegion.enumerateDates(from: DateInRegion(currentWeekStart), to: DateInRegion(currentWeekEnd), increment: 1.days)
            
            var suma = "00:00:00"
            days.removeAll()
            
            for entry in weekTimesheet {
                for weekDay in dates {
                    
                    let dateDay    = entry[ts_date]
                    let dateTotal  = entry[ts_total_time]
                    let addToDay   = weekDay.toFormat(formatSec)
                    let dayTotal   = timePerDay[weekDay.toFormat(formatDay)] ?? "00:00:00"
                    
                    if DateInRegion(dateDay)!.isInside(date: weekDay, granularity: .day) {
                        suma = addTime(timeToAdd: dateTotal, addToDay: addToDay, dailyPrevious: dayTotal)
                        timePerDay[weekDay.toFormat(formatDay)] = suma
                    }

                    dayTotalVar = suma
                    
                }
            }
            
            for tsDay in dates {
                let dan = tsDay.toFormat(formatDay)
                
                
                for ts in timePerDay {
                    
                    if ts.key == dan {
                        let earnings = ts.value.getEarnings()
                        days.append([
                            "CellDay":    ts.key,
                            "CellHours":  ts.value,
                            "CellEarned": earnings
                        ])
                        _ = addTime(timeToAdd: ts.value)
                    }
                }
            }

            tableView.reloadData()
            lblTotalEarnings.stringValue = lblTotalHours.stringValue.getEarnings()
        } catch {
            NSAlert.showAlert(title: "ERROR", message: "Error with DB!", style: .critical)
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
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

                let result = totalHours.toFormat("HH:mm:ss")

                lblTotalHours.stringValue = result
                return result
            } else {
                // One day calculation
                let result = DateInRegion(dailyPrevious)! + h.hours + m.minutes + s.seconds
                return result.toFormat("HH:mm:ss")
            }
        } else {
            return ""
        }
    }
    
    func subtractTime(time: String, fromTime: String)-> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm:ss"
        
        if let t = DateInRegion(time) {
            let h         = t.hour
            let m         = t.minute
            let s         = t.second
            
            let result = DateInRegion(fromTime)! - h.hours - m.minutes - s.seconds

            return result.toFormat("HH:mm:ss")
        } else {
            return fromTime
        }
    }
}

extension WeekTimeSheetViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (days.count)
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let field = days[row]
        
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = field[tableColumn!.identifier.rawValue]!
        
        return cell
    }
}


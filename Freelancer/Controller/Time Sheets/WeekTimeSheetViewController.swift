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

    var totalHoursDay: TimeInterval = 0
    var totalHoursWeek: TimeInterval = 0
    var newTimeDay: TimeInterval    = 0
    var newTimeWeek: TimeInterval = 0
    
    var days:[[String:String]] = [[:]]
    var timePerDay = [String:(String)]()
    
//    var dayPrevious:TimeInterval = 0
    
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
            
            let weekTimesheet = try db.prepare(query)

            let dates = DateInRegion.enumerateDates(from: DateInRegion(currentWeekStart), to: DateInRegion(currentWeekEnd), increment: 1.days)
            
            days.removeAll()
            
            fmt.dateFormat = formatWeekLong
            var sum = ""
            
            for entry in weekTimesheet {
                for weekDay in dates {
                    let dateDay       = entry[ts_date]
                    let dateTotalTime = entry[ts_total_time]

                    if DateInRegion(dateDay)!.isInside(date: weekDay, granularity: .day) {
                        sum = addTime(timeToAdd: dateTotalTime, dailyPrevious: totalHoursDay)
                        timePerDay[weekDay.toFormat(formatDay)] = sum
                        
                        let t = DateInRegion(dateTotalTime)
                        let h = t!.hour
                        let m = t!.minute
                        let s = t!.second
                        let t1 = h + m + s
                        
                        totalHoursDay = TimeInterval(sum)! - TimeInterval(t1)
                        
                    }
                }
                
            }
             print(timePerDay)
            for tsDay in dates {
                let dayIterator = tsDay.toFormat(formatDay)

                for ts in timePerDay {
                    if ts.key == dayIterator {
                        let earnings = ts.value.getEarnings()
                        days.append([
                            "CellDay":    ts.key,
                            "CellHours":  ts.value,
                            "CellEarned": earnings
                        ])
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

    func addTime(timeToAdd: String, dailyPrevious: TimeInterval = 0)-> String {
        let time = DateInRegion(timeToAdd)
        let h        = time!.hour * 3600
        let m        = time!.minute * 60
        let s        = time!.second
        let sum      = h + m + s
        
        if dailyPrevious.isNaN {
            // Weekly calculation
            newTimeDay     = totalHoursDay + TimeInterval(sum)
            totalHoursDay  = newTimeDay

            lblTotalHours.stringValue = totalHoursDay.toClock()
            return totalHoursWeek.toClock()
        } else {
            // One day calculation
            let result = TimeInterval(sum) //- dailyPrevious 
            totalHoursDay = result
            return String(result)
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


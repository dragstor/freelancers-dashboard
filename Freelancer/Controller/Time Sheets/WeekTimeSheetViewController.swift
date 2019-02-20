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
    
    var currentWeekStart = Date().dateAt(.startOfWeek).timeIntervalSince1970
    var currentWeekEnd   = Date().dateAt(.endOfWeek).timeIntervalSince1970
    
    let ts_id           = Expression<TimeInterval>("id")
    let ts_date         = Expression<TimeInterval>("ts_date")
    let ts_total_time   = Expression<TimeInterval>("ts_total_time")
    
    let fmt             = DateFormatter()
    let format          = "yyyy-MM-dd HH:mm:ss"
    let formatSec       = "HH:mm:ss"
    let formatDay       = "EEEE"
    let formatWeekShort = "yyyy-MM-dd"
    let formatWeekLong  = "yyyy-MM-dd HH:mm:ss"

    var totalHoursDay: TimeInterval  = 0
    var totalHoursWeek: TimeInterval = 0
    
    var days:[[String:String]] = [[:]]
    var timePerDay             = [String:(TimeInterval)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftDate.defaultRegion = Region.current
        
        lblCurrentWeek.stringValue = "\(DateInRegion(seconds: currentWeekStart).toFormat(formatWeekShort)) to \(DateInRegion(seconds: currentWeekEnd).toFormat(formatWeekShort))"
        
        do{
            let db = try Connection("\( NSApp.supportFolderGet())/db.sqlite3")
            let tableTimesheets = Table("timesheets_interval")
            
            let dayStart = currentWeekStart
            let dayEnd   = currentWeekEnd
            
            let query = tableTimesheets
                .select(ts_id, ts_date, ts_total_time)
                .filter(dayStart...dayEnd ~= ts_date)
                .order(ts_id)
            
            let weekTimesheet = try db.prepare(query)

            let dates = DateInRegion.enumerateDates(from: DateInRegion(seconds: currentWeekStart), to: DateInRegion(seconds: currentWeekEnd), increment: 1.days)
            
            days.removeAll()
            
            fmt.dateFormat = formatWeekLong
            
            var sum:TimeInterval = 0
            
            for entry in weekTimesheet {
                let dateDay       = entry[ts_date]
                let dateTotalTime = entry[ts_total_time]
                for weekDay in dates {
                    if DateInRegion(seconds: dateDay).isInside(date: weekDay, granularity: .day) {
                        totalHoursDay += dateTotalTime
                        sum           += totalHoursDay
                        let tmp       = TimeInterval(timePerDay[weekDay.toFormat(formatDay)] ?? 0) + totalHoursDay
                        
                        timePerDay[weekDay.toFormat(formatDay)] = tmp
                        
                        totalHoursWeek = sum
                        totalHoursDay  = 0
                    }
                }
            }
            
            for tsDay in dates {
                let dayIterator = tsDay.toFormat(formatDay)

                for ts in timePerDay {
                    if ts.key == dayIterator {
                        let hours    = ts.value
                        let earnings = hours.getEarnings()

                        days.append([
                            "CellDay":    ts.key,
                            "CellHours":  hours.toString(),
                            "CellEarned": earnings
                        ])
                    }
                }
            }
            
            lblTotalHours.stringValue    = totalHoursWeek.toString()
            lblTotalEarnings.stringValue = totalHoursWeek.getEarnings()
            
            tableView.reloadData()
        } catch {
            NSAlert.showAlert(title: "ERROR", message: "Error with DB!", style: .critical)
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
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

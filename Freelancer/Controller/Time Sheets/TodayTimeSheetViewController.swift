//
//  TodayTimeSheetViewController.swift
//  Freelancer
//
//  Created by Nikola on 2/4/19.
//  Copyright © 2019 Stojković. All rights reserved.
//

import Foundation
import Cocoa
import SQLite
import SwiftDate

class TodayTimeSheetViewController: NSViewController {
    
    
    
    @IBOutlet weak var lblTotalHours: NSTextField!
    @IBOutlet weak var lblTotalEarnings: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var cellFrom: NSTableCellView!
    @IBOutlet weak var cellTo: NSTableCellView!
    @IBOutlet weak var cellTotal: NSTableCellView!
    @IBOutlet weak var cellEarned: NSTableCellView!
    @IBOutlet weak var currentDay: NSTextField!
    
    
    let ts_date         = Expression<TimeInterval>("ts_date")
    let ts_from         = Expression<TimeInterval>("ts_from")
    let ts_to           = Expression<TimeInterval>("ts_to")
    let ts_total_time   = Expression<TimeInterval>("ts_total_time")
    let ts_approved     = Expression<Bool>("ts_approved")
    
    
    
    let fmt       = DateFormatter()
    let format    = "yyyy-MM-dd HH:mm:ss"
    let formatSec = "HH:mm:ss"
    
    var totalHours: TimeInterval = 0
    var newTime: TimeInterval    = 0
    var timeClock:TimeInterval   = 0
    var data:[[String:String]]   = [[:]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SwiftDate.defaultRegion = Region.current

        do {
            let db = try Connection("\( NSApp.supportFolderGet())/db.sqlite3")
            let tableTimesheets = Table("timesheets_interval")
            
            let now = DateInRegion().convertTo(region: Region.current)
            let today_start = now.dateAtStartOf(.day).timeIntervalSince1970
            let today_end   = now.dateAtEndOf(.day).timeIntervalSince1970
        
            let query = tableTimesheets
                .select(ts_date, ts_from, ts_to, ts_total_time)
                .filter(
                    today_start...today_end ~= ts_date
            )
            
            let today_timesheet = try db.prepare(query)
        
            data.removeAll()
        
            var timeTmp:TimeInterval = 0
            for entry in today_timesheet {
                do {
                    fmt.dateFormat = formatSec
                    let date_from  = Date(timeIntervalSince1970: entry[ts_from]).toFormat(formatSec)
                    let date_to    = Date(timeIntervalSince1970: entry[ts_to]).toFormat(formatSec)
                    let date_total = entry[ts_total_time].toString()

                    data.append(
                        [
                            "CellFrom": date_from,
                            "CellTo": date_to,
                            "CellTotal": date_total,
                            "CellEarned": entry[ts_total_time].getEarnings()
                        ]
                    )
                    timeTmp = addTime(timeToAdd: entry[ts_total_time])
                }
            }

            tableView.reloadData()
            
            currentDay.stringValue = now.toFormat("EEEE, MMM dd, YYYY") //.getDay()
            lblTotalEarnings.stringValue = timeTmp.getEarnings()
        } catch {
            NSAlert.showAlert(title: "Error loading timesheets", message: "Unable to load timesheet!", style: .critical)
        }
    }
  
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func addTime(timeToAdd: TimeInterval) -> TimeInterval {

        let time = DateInRegion(seconds: timeToAdd)
        let h = time.hour * 3600
        let m = time.minute * 60
        let s = time.second
        
        let sum = h + m + s
        
        let previous = totalHours
        newTime = previous + TimeInterval(sum)
        totalHours = newTime
        
        lblTotalHours.stringValue = newTime.toString()

        return newTime
    }
}

extension TodayTimeSheetViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (data.count)
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let field = data[row]
        
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = field[tableColumn!.identifier.rawValue]!
        
        return cell
    }
}


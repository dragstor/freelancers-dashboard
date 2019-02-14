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
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var cellFrom: NSTableCellView!
    @IBOutlet weak var cellTo: NSTableCellView!
    @IBOutlet weak var cellTotal: NSTableCellView!
    @IBOutlet weak var currentDay: NSTextField!
    
    let ts_date         = Expression<String>("ts_date")
    let ts_from         = Expression<String>("ts_from")
    let ts_to           = Expression<String>("ts_to")
    let ts_total_time   = Expression<String>("ts_total_time")
    let ts_approved     = Expression<Int64>("ts_approved")
    
    
    
    let fmt         = DateFormatter()
    let format      = "yyyy-MM-dd HH:mm:ss"
    let format_sec  = "HH:mm:ss"
    
    var totalHours    = DateInRegion().dateAt(.startOfDay) // dateAtStartOf(.day)
    var newTime       = DateInRegion().dateAt(.startOfDay) // StartOf(.day)
    
    
    var data:[[String:String]] = [[:]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        do {
            let db = try Connection("\( NSApp.supportFolderGet())/db.sqlite3")
            let tableTimesheets = Table("timesheets")
            
            let now = DateInRegion()
            let today_start = String(now.dateAtStartOf(.day).toFormat(format))
            let today_end   = String(now.dateAtEndOf(.day).toFormat(format))
        
            let query = tableTimesheets
                .select(*)
                .filter(
                    today_start...today_end ~= ts_date
            )
            
            let today_timesheet = try db.prepare(query)
        
            data.removeAll()
        
            for entry in today_timesheet {
                do {
                    fmt.dateFormat = format_sec
                    let date_from  = entry[ts_from].toDate()?.toFormat(format_sec)
                    let date_to    = entry[ts_to].toDate()?.toFormat(format_sec)
                    let date_total = entry[ts_total_time]

                    data.append(
                        [
                            "CellFrom": date_from!,
                            "CellTo": date_to!,
                            "CellTotal": date_total
                        ]
                    )
                    addTime(timeToAdd: date_total)
                    
                }
            }

            tableView.reloadData()
            
            currentDay.stringValue = now.toFormat("EEEE, MMM dd, YYYY") //.getDay()
        } catch {
            NSAlert.showAlert(title: "Error loading timesheets", message: "Unable to load timesheet!", style: .critical)
        }
    }
  
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func addTime(timeToAdd: String) -> Void {
        let fmt = DateFormatter()
        fmt.dateStyle  = .none
        fmt.timeStyle  = .medium
        fmt.dateFormat = "HH:mm:ss"

        if let time = DateInRegion(timeToAdd) {
            let h = time.hour
            let m = time.minute
            let s = time.second
            newTime = totalHours + h.hours + m.minutes + s.seconds
            totalHours = newTime
            lblTotalHours.stringValue = totalHours.toFormat("HH:mm:ss")
        }
        
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


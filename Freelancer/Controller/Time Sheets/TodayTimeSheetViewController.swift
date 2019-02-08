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

class TodayTimeSheetViewController: NSViewController {
    
    
    
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
    
    

    let fmt = DateFormatter()
    
    var data:[[String:String]] = [[:]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let db = try? Connection("\( NSApp.supportFolderGet())/db.sqlite3")
            let tableTimesheets = Table("timesheets")
        
        
            fmt.dateFormat = "hh:mma"
            let today_start: Date = Date().startOfDay
            let today_end: Date   = Date().endOfDay
    //        let today_timesheet   = try! db!.prepare(tableTimesheets.filter(ts_date >= fmt.string(from: today_start) && ts_date <= fmt.string(from: today_end)))
    //        let today_timesheet   = try! db!.prepare(tableTimesheets)
        
            let query = tableTimesheets.select(*)
                .filter(ts_date >= fmt.string(from: today_start) && ts_date <= fmt.string(from: today_end))
        
            print(query)
        
            let today_timesheet = try! db?.prepare(query)
        
            data.removeAll()
        
            
            for entry in today_timesheet! {
                do {
    //                let date_from = (try! entry.get(ts_from)).toTime()
    //                let date_to   = try! entry.get(ts_to).toTime()
                    let date_from  = entry[ts_from].toTime()
                    let date_to    = entry[ts_to].toTime()
                    let date_total = entry[ts_total_time]
                    
    //                NSAlert.showAlert(title: "Sadrzaj ", message: date_from?.toString())

                    data.append(
                        [
                            "CellFrom": (date_from?.toString())!,
                            "CellTo": (date_to?.toString())!,
                            "CellTotal": date_total
                        ]
                    )

                } catch {
                    NSAlert.showAlert(title: "ERROR", message: "\(error)")
                }
            }
    //        catch let Result.error(message, code, statement) where code == SQLITE_ANY {
    //            NSAlert.showAlert(title: "constraint failed: \(message)", message: "\(statement)")
    //        } catch let error {
    //            NSAlert.showAlert(title: "Read FAIL", message: "\(error)")
    //                print("insertion failed: \(error)")
    //        }
            print(data)
        
            // reload tableview
            tableView.reloadData()
        
        
            currentDay.stringValue = Date().getDay()
        } catch {
            NSAlert.showAlert(title: "ERROR", message: "\(error)")
        }
    }
  
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
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

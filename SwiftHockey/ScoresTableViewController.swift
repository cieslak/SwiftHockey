//
//  ScoresTableViewController.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController {
    
    let dateFormatter = NSDateFormatter()
    var leagueFilter = League.NHL
    var currentDate = NSDate().dateByRemovingTime()
    var filteredGames = Game[]()
    
    var datePicker = UIDatePicker()
    var isShowingDatePicker = false
    var isRefreshing = false
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem.title = leagueFilter.toRaw()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker.datePickerMode = .Date
        datePicker.maximumDate = NSDate()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        refresh()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return filteredGames.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: GameTableViewCell = tableView.dequeueReusableCellWithIdentifier("scoreCell") as GameTableViewCell
        cell.game = filteredGames[indexPath.row]
        return cell
    }
    
    func refresh() {
        
        if isRefreshing {return}
        
        isRefreshing = true
        
        func enableInterface(enable: Bool) {
            navigationItem.leftBarButtonItem.enabled = enable
            navigationItem.rightBarButtonItem.enabled = enable
            refreshControl.enabled = enable
        }
        
        func showAlertWithTitle(title: String, #message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
            alertController.addAction(alertAction)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(alertController, animated: true, completion: nil)
                enableInterface(true)
            }
        }
        
        self.filteredGames = Game[]()
        self.tableView.reloadData()
        
        enableInterface(false)
        
        refreshControl.beginRefreshing()
        
        let currentDateString = dateFormatter.stringFromDate(currentDate)
        
        sharedScoreManager.retrieveScoresForDateString(currentDateString) {
            (response) in
            
            switch response {
            case .Error(let error):
                showAlertWithTitle("Error Loading Scores", message: error.localizedDescription)
                return
            case .Response(let games):
                switch self.leagueFilter {
                case .All:
                    self.filteredGames = games
                default:
                    self.filteredGames = games.filter {
                        $0.league == self.leagueFilter
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    enableInterface(true)
                    self.refreshControl.endRefreshing()
                }
                
                if self.filteredGames.count == 0 {
                    var dateString = self.dateFormatter.stringFromDate(self.currentDate)
                    showAlertWithTitle("No Games Scheduled", message: "No hockey for \(dateString). 😭")
                }
                self.isRefreshing = false
            }
        }
    }
    
    @IBAction func dateButtonTouched(sender : AnyObject) {
        if isShowingDatePicker {
            
            UIView.animateWithDuration(0.2, animations: {
                self.datePicker.alpha = 0.0
                }, completion: {
                    finished in
                    self.tableView.tableHeaderView = nil
                })
            
            let newDate = datePicker.date.dateByRemovingTime()
            let isSameDate = newDate == currentDate
            currentDate = newDate
            if !isSameDate {refresh()}
            
            var dateString = dateFormatter.stringFromDate(newDate)
            if NSDate().dateByRemovingTime() == currentDate {
                dateString = "Today"
            }
            navigationItem.leftBarButtonItem.title = dateString
            
        } else {
            
            datePicker.alpha = 0.0
            
            UIView.animateWithDuration(0.2) {
                self.datePicker.alpha = 1.0
                self.tableView.tableHeaderView = self.datePicker
            }
            
            navigationItem.leftBarButtonItem.title = "Done"
            
        }
        
        isShowingDatePicker = !isShowingDatePicker
    }
    
    @IBAction func filterButtonPressed(sender : AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Select a league to view", preferredStyle: UIAlertControllerStyle.ActionSheet);
        
        for string in ["All", "NHL", "AHL", "OHL", "WHL", "QMJHL"] {
            let action = UIAlertAction(title: string, style: UIAlertActionStyle.Default) {
                action in
                self.leagueFilter = League.fromRaw(action.title)!
                self.navigationItem.rightBarButtonItem.title = self.leagueFilter.toRaw()
                self.refresh()
            }
            alertController.addAction(action)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

extension NSDate {
    func dateByRemovingTime() -> NSDate {
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(flags, fromDate: self)
        return calendar.dateFromComponents(components)
    }
}






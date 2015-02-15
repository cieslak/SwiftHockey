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
    let scoreManager = ScoreManager()
    var leagueFilter = League.NHL
    var currentDate = NSDate().dateByRemovingTime()
    var datePicker = UIDatePicker()
    var isShowingDatePicker = false
    var isRefreshing = false
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.title = leagueFilter.rawValue
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker.datePickerMode = .Date
        datePicker.maximumDate = NSDate()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        refresh(currentDate)
    }
    
    func enableInterface(enable: Bool) {
        navigationItem.leftBarButtonItem?.enabled = enable
        navigationItem.rightBarButtonItem?.enabled = enable
        refreshControl?.enabled = enable
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        alertController.addAction(alertAction)
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true, completion: nil)
            self.enableInterface(true)
        }
    }
    
    func refresh(date: NSDate) {
        
        if !isRefreshing {
            
            isRefreshing = true
            enableInterface(false)
            refreshControl?.beginRefreshing()
            
            let currentDateString = dateFormatter.stringFromDate(date)
            
            scoreManager.retrieveScoresForDateString(currentDateString, league:leagueFilter) {
                response in
                
                switch response {
                case .Error(let error):
                    self.showAlertWithTitle("Error Loading Scores", message: error.localizedDescription)
                case .Response(let games):
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        self.enableInterface(true)
                        self.refreshControl?.endRefreshing()
                    }
                    if games.count == 0 {
                        var dateString = self.dateFormatter.stringFromDate(self.currentDate)
                        self.showAlertWithTitle("No Games Scheduled", message: "No hockey for \(dateString). 😭")
                    }
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
            if newDate != currentDate {refresh(newDate)}
            currentDate = newDate
            
            let dateString: String
            if NSDate().dateByRemovingTime() == currentDate {
                dateString = "Today"
            } else {
                dateString = dateFormatter.stringFromDate(newDate)
            }
            
            navigationItem.leftBarButtonItem?.title = dateString
            
        } else {
            
            datePicker.alpha = 0.0
            
            UIView.animateWithDuration(0.2) {
                self.datePicker.alpha = 1.0
                self.tableView.tableHeaderView = self.datePicker
            }
            
            navigationItem.leftBarButtonItem?.title = "Done"
            
        }
        
        isShowingDatePicker = !isShowingDatePicker
    }
    
    @IBAction func filterButtonPressed(sender : AnyObject) {
        let alertController = UIAlertController(title: "Select a league to view", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet);
        
        for string in ["All", "NHL", "AHL", "OHL", "WHL", "QMJHL"] {
            let action = UIAlertAction(title: string, style: UIAlertActionStyle.Default) {
                [unowned self] (action) in
                self.leagueFilter = League(rawValue: action.title)!
                self.navigationItem.rightBarButtonItem?.title = string
                self.refresh(self.currentDate)
            }
            alertController.addAction(action)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

extension ScoresTableViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreManager.games.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: GameTableViewCell = tableView.dequeueReusableCellWithIdentifier("scoreCell") as! GameTableViewCell
        cell.game = scoreManager.games[indexPath.row]
        return cell
    }
}

extension NSDate {
    func dateByRemovingTime() -> NSDate {
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(flags, fromDate: self)
        return calendar.dateFromComponents(components)!
    }
}





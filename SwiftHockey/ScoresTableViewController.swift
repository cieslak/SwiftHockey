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
    var isShowingDatePicker = false
 
    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem.title = leagueFilter.toRaw()
        dateFormatter.dateFormat = "MM/dd/yy"
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.beginRefreshing()
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
        let game = filteredGames[indexPath.row]
        cell.awayShortNameLabel.text = game.awayTeam.shortName
        cell.homeShortNameLabel.text = game.homeTeam.shortName
        cell.awayScoreLabel.text = "\(game.awayTeamScore)"
        cell.homeScoreLabel.text = "\(game.homeTeamScore)"
        cell.awayTeamCityLabel.text = game.awayTeam.cityName
        cell.homeTeamCityLabel.text = game.homeTeam.cityName
        cell.awayTeamNameLabel.text = game.awayTeam.teamName
        cell.homeTeamNameLabel.text = game.homeTeam.teamName
        if let periodExists = game.period {
            cell.periodLabel.text = periodExists
        }
        
        return cell
    }
    
    func refresh() {
        
        func enableInterface(enable: Bool) {
            navigationItem.leftBarButtonItem.enabled = enable
            navigationItem.rightBarButtonItem.enabled = enable
            refreshControl.enabled = enable
        }
        
        enableInterface(false)
        
        let currentDateString = dateFormatter.stringFromDate(currentDate)
        
        ScoreManager.sharedInstance.retrieveScoresForDateString(currentDateString) {
            (games, error) in
            
            if let errorOccurred = error {
                let alertController = UIAlertController(title: "Error Loading Scores", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
                alertController.addAction(alertAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                    enableInterface(true)
                }
            }
            
            switch self.leagueFilter {
            case .All:
                self.filteredGames = ScoreManager.sharedInstance.games
            default:
                self.filteredGames = ScoreManager.sharedInstance.games.filter {
                    game in game.league == self.leagueFilter
                }
            }
                
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                enableInterface(true)
                self.refreshControl.endRefreshing()
            }

            if self.filteredGames.count == 0 {
                let alertController = UIAlertController(title: "No Games Scheduled", message: "No hockey today. 😭", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
                alertController.addAction(alertAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                    enableInterface(true)
                }
            }
        }
    }
    
    @IBAction func dateButtonTouched(sender : AnyObject) {
        if isShowingDatePicker {
            
        } else {
            
        }
    }
    
    @IBAction func filterButtonPressed(sender : AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Select a league to view", preferredStyle: UIAlertControllerStyle.ActionSheet);
        
        for string in ["All", "NHL", "AHL", "OHL", "WHL", "QMJHL"] {
            let action = UIAlertAction(title: string, style: UIAlertActionStyle.Default) {
                (action) in
                    self.leagueFilter = League.fromRaw(action.title)!
                    self.navigationItem.rightBarButtonItem.title = self.leagueFilter.toRaw()
                    self.filteredGames = Game[]()
                    self.tableView.reloadData()
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






//
//  ScoresTableViewController.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController {
        
    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationItem.title = "Hockey Scores"
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.beginRefreshing()
        refresh()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ScoreManager.sharedInstance.games.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: GameTableViewCell = tableView.dequeueReusableCellWithIdentifier("scoreCell") as GameTableViewCell
        let game = ScoreManager.sharedInstance.games[indexPath.row]
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
        ScoreManager.sharedInstance.retrieveScores {
            (games, error) -> () in
            if let errorOccurred = error {
                let alertController = UIAlertController(title: "Error Loading Scores", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            if ScoreManager.sharedInstance.games.count == 0 {
                let alertController = UIAlertController(title: "No Games Scheduled", message: "No hockey today. 😭", preferredStyle: UIAlertControllerStyle.Alert);
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
        }
    }
    
}

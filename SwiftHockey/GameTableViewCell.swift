//
//  GameTableViewCell.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/4/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet var homeShortNameLabel : UILabel
    @IBOutlet var awayShortNameLabel : UILabel
    @IBOutlet var homeScoreLabel : UILabel
    @IBOutlet var awayScoreLabel : UILabel
    @IBOutlet var homeTeamCityLabel : UILabel
    @IBOutlet var homeTeamNameLabel : UILabel
    @IBOutlet var awayTeamCityLabel : UILabel
    @IBOutlet var awayTeamNameLabel : UILabel
    @IBOutlet var periodLabel : UILabel
    
    var game: Game? = nil  {
    didSet {
        if let newGame = game {
            self.awayShortNameLabel.text = newGame.awayTeam.shortName
            self.homeShortNameLabel.text = newGame.homeTeam.shortName
            self.awayScoreLabel.text = "\(newGame.awayTeamScore)"
            self.homeScoreLabel.text = "\(newGame.homeTeamScore)"
            self.awayTeamCityLabel.text = newGame.awayTeam.cityName
            self.homeTeamCityLabel.text = newGame.homeTeam.cityName
            self.awayTeamNameLabel.text = newGame.awayTeam.teamName
            self.homeTeamNameLabel.text = newGame.homeTeam.teamName
            if let periodExists = newGame.period {
                self.periodLabel.text = periodExists
            }
        } else {
            for view: AnyObject in contentView.subviews {
                if let label = view as? UILabel {
                    label.text = ""
                }
            }
        }
    }
    }
    
}

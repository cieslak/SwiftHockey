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
}

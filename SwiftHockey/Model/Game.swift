//
//  Game.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import Foundation

class Game {

    let league: League
    let awayTeam: Team
    let homeTeam: Team
    var awayTeamScore = 0
    var homeTeamScore = 0
    var playing = false
    var period: String? = nil

    init(league: League, awayTeam: Team, homeTeam: Team) {
        self.league = league
        self.awayTeam = awayTeam
        self.homeTeam = homeTeam
    }
    
}
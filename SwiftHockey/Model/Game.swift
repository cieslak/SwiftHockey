//
//  Game.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import Foundation

public class Game {
    
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
    
    
    class func gameWithJSON(jsonDict: NSDictionary) -> Game? {
        
        if let
            leagueString = jsonDict["event"] as? String, league = League(rawValue: leagueString),
            awayTeamCity: String? = jsonDict["awayTeamCity"] as? String,
            awayTeamName: String? = jsonDict["awayTeamName"] as? String,
            shortAwayTeam: String? = jsonDict["shortAwayTeam"] as? String,
            homeTeamCity: String? = jsonDict["homeTeamCity"] as? String,
            homeTeamName: String? = jsonDict["homeTeamName"] as? String,
            shortHomeTeam: String? = jsonDict["shortHomeTeam"] as? String
        {
            let homeTeam = Team(cityName: homeTeamCity!, teamName: homeTeamName!, shortName: shortHomeTeam!.uppercaseString)
            let awayTeam = Team(cityName: awayTeamCity!, teamName: awayTeamName!, shortName: shortAwayTeam!.uppercaseString)
            let game = Game(league: league, awayTeam: awayTeam, homeTeam: homeTeam)
            
            if let isPlaying: Int? = jsonDict["isPlaying"] as? Int {
                game.playing = (isPlaying > 0) ? true : false
            }
            
            if let period: String? = jsonDict["period"] as? String {
                game.period = period
            }
            
            if let awayTeamScore = jsonDict["awayScore"] as? String, scoreIntValue = awayTeamScore.toInt() {
                game.awayTeamScore = scoreIntValue
            }
            
            if let homeTeamScore = jsonDict["homeScore"] as? String, scoreIntValue = homeTeamScore.toInt() {
                game.homeTeamScore = scoreIntValue
            }
            
            return game
        }
        
        return nil
    }
}
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
    
    
    class func gameWithJSON(jsonDict: NSDictionary) -> Game? {
        
        let leagueString: String? = jsonDict["event"] as? String
        if leagueString == nil {
            return nil
        }
        let league = League.fromRaw(leagueString!)
        
        let awayTeamCity: String? = jsonDict["awayTeamCity"] as? String
        let awayTeamName: String? = jsonDict["awayTeamName"] as? String
        let shortAwayTeam: String? = jsonDict["shortAwayTeam"] as? String
        if awayTeamCity == nil || awayTeamName == nil ||  shortAwayTeam == nil {
            return nil
        }
        let awayTeam = Team(cityName: awayTeamCity!, teamName: awayTeamName!, shortName: shortAwayTeam!.uppercaseString)
        
        let homeTeamCity: String? = jsonDict["homeTeamCity"] as? String
        let homeTeamName: String? = jsonDict["homeTeamName"] as? String
        let shortHomeTeam: String? = jsonDict["shortHomeTeam"] as? String
        if homeTeamCity == nil || homeTeamName == nil ||  shortHomeTeam == nil {
            return nil
        }
        let homeTeam = Team(cityName: homeTeamCity!, teamName: homeTeamName!, shortName: shortHomeTeam!.uppercaseString)
        
        let game = Game(league: league!, awayTeam: awayTeam, homeTeam: homeTeam)
        
        let isPlaying: Int? = jsonDict["isPlaying"] as? Int
        
        if isPlaying == nil {
            return nil
        }
        
        game.playing = (isPlaying > 0) ? true : false
        
        if let awayTeamScore = jsonDict["awayScore"] as? String {
            if let scoreIntValue = awayTeamScore.toInt() {
                game.awayTeamScore = scoreIntValue
            }
        }
        
        if let homeTeamScore = jsonDict["homeScore"] as? String {
            if let scoreIntValue = homeTeamScore.toInt() {
                game.homeTeamScore = scoreIntValue
            }
        }
        
        if let period: String? = jsonDict["period"] as? String {
            game.period = period
        }
        
        return game
        
    }

    
}
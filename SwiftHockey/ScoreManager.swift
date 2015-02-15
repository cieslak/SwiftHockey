//
//  ScoreManager.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

let sharedScoreManager = ScoreManager()

public enum Result {
    case Response([Game])
    case Error(NSError)
}


public class ScoreManager: NSObject {
    
    private let apiBaseURL = "http://api.hockeystreams.com/Scores?key=7344b5c9c89372d26b068022c9f28175&date="
    
    private let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
    
    public var games = [Game]()
    
    public func retrieveScoresForDateString(dateString: String, league: League, completion: (Result) -> ()) {
        let url: NSURL? = NSURL(string: "\(apiBaseURL)\(dateString)")
        
        let request = NSMutableURLRequest(URL: url!)
        let task = urlSession.downloadTaskWithRequest(request) {
            (url, response, error) in
            
            if let errorOccurred = error {
                completion(Result.Error(errorOccurred))
                return
            } else {
                var gameArray = [Game]()
                let gameData = NSData(contentsOfURL: url)
                var jsonError: NSError? = nil
                if let data = gameData {
                    let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &jsonError)
                    if let errorOccurred = jsonError {
                        completion(Result.Error(errorOccurred))
                        return
                    }
                    if jsonObject is NSDictionary {
                        let receivedGamesArray: NSArray? = jsonObject!["scores"] as? NSArray
                        if let verifiedGamesArray = receivedGamesArray {
                            for gameDict: AnyObject in verifiedGamesArray{
                                if let game = Game.gameWithJSON(gameDict as! NSDictionary) {
                                    gameArray.append(game)
                                }
                            }
                        }
                    }
                }
                
                switch league {
                case .All:
                    self.games = gameArray
                default:
                    self.games = gameArray.filter {
                        $0.league == league
                    }
                }
                completion(Result.Response(self.games))
            }
        }
        task.resume()
    }
    
}

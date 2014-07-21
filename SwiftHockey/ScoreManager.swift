//
//  ScoreManager.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

let sharedScoreManager = ScoreManager()

enum Result<T, U> {
    case Response(@auto_closure () -> T)
    case Error(@auto_closure() -> U)
}


class ScoreManager: NSObject, NSURLSessionDelegate {
    
    let apiBaseURL = "https://api.hockeystreams.com/Scores?key=7344b5c9c89372d26b068022c9f28175&date="
    
    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
    
    var games = [Game]()
    
    func retrieveScoresForDateString(dateString: String, league: League, completion: (Result<[Game],NSError>) -> ()) {

        let url: NSURL? = NSURL(string: "\(apiBaseURL)\(dateString)")
        let request = NSMutableURLRequest(URL: url)
        let task = urlSession.downloadTaskWithRequest(request) {
            (url, response, error) in
            
            if let errorOccurred = error {
                completion(Result.Error(errorOccurred))
                return
            } else {
                var gameArray = [Game]()
                let data = NSData(contentsOfURL: url)
                var jsonError: NSError? = nil
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &jsonError)
                if let errorOccurred = jsonError {
                    completion(Result.Error(errorOccurred))
                    return
                }
                if jsonObject is NSDictionary {
                    let receivedGamesArray: NSArray? = jsonObject!["scores"] as? NSArray
                    if let verifiedGamesArray = receivedGamesArray {
                        for gameDict: AnyObject in verifiedGamesArray{
                            if gameDict as? NSDictionary {
                                if let game = Game.gameWithJSON(gameDict as NSDictionary) {
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

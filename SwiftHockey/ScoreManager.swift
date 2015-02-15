//
//  ScoreManager.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

public enum Result {
    case Response([Game])
    case Error(NSError)
}


public class ScoreManager: NSObject {
    
    private let apiBaseURL = "http://api.hockeystreams.com/Scores?key=7344b5c9c89372d26b068022c9f28175&date="
    
    private let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
    
    private var gameArray: [Game]?

    public var games: [Game] {
        return gameArray ?? [Game]()
    }
    
    public func retrieveScoresForDateString(dateString: String, league: League, completion: (Result) -> ()) {
        let url: NSURL? = NSURL(string: "\(apiBaseURL)\(dateString)")
        
        let request = NSMutableURLRequest(URL: url!)
        let task = urlSession.downloadTaskWithRequest(request) {
            (url, response, error) in
            
            if let errorOccurred = error {
                completion(Result.Error(errorOccurred))
            } else {
                var newGameArray = [Game]()
                var jsonError: NSError? = nil
                if let data = NSData(contentsOfURL: url),
                    let parsedData: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &jsonError),
                    jsonDict = parsedData as? NSDictionary,
                    scores = jsonDict["scores"] as? NSArray {
                        for gameData: AnyObject in scores {
                            if let gameDict = gameData as? NSDictionary,
                                let game = Game.gameWithJSON(gameDict) {
                                    newGameArray.append(game)
                            }
                        }
                }
                if let errorOccurred = jsonError {
                    completion(Result.Error(errorOccurred))
                } else {
                    switch league {
                    case .All:
                        self.gameArray = newGameArray
                    default:
                        self.gameArray = newGameArray.filter {
                            $0.league == league
                        }
                    }
                    completion(Result.Response(self.games))
                }
            }
        }
        task.resume()
    }
}

//
//  ScoreManager.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

let sharedScoreManager = ScoreManager()

enum ScoreRequestResponse {
    case Response (Game[])
    case Error (NSError)
}

class ScoreManager: NSObject, NSURLSessionDelegate {
    
    let apiBaseURL = "https://api.hockeystreams.com/Scores?key=7344b5c9c89372d26b068022c9f28175&date="

    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
    
    var games = Game[]()
    
    func retrieveScoresForDateString(dateString: String, completionClosure: (ScoreRequestResponse) -> ()) {
        let url = NSURL(string: "\(apiBaseURL)\(dateString)")
        let request = NSMutableURLRequest(URL: url)
        let task = urlSession.downloadTaskWithRequest(request, completionHandler: {
            (url, response, error) in
            
            if let errorOccurred = error {
                completionClosure(ScoreRequestResponse.Error(error))
                return
            } else {
                var gameArray = Game[]()
                let data = NSData(contentsOfURL: url)
                var jsonError: NSError? = nil
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &jsonError)
                if let errorOccurred = error {
                    completionClosure(ScoreRequestResponse.Error(error))
                    return
                }
                if jsonObject is NSDictionary {
                    let receivedGamesArray: NSArray = jsonObject!["scores"] as NSArray
                    for gameDict: AnyObject in receivedGamesArray {
                        if gameDict as? NSDictionary {
                            if let game = Game.gameWithJSON(gameDict as NSDictionary) {
                                gameArray.append(game)
                            }
                        }
                    }
                }
                self.games = gameArray
                completionClosure(ScoreRequestResponse.Response(self.games))
            }
            })
        task.resume()
    }
    
}

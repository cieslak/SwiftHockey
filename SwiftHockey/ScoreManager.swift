//
//  ScoreManager.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import UIKit

class ScoreManager: NSObject, NSURLSessionDelegate {
    
    class var sharedInstance: ScoreManager {
        get {
            struct StaticInstance {
                static var onceToken: dispatch_once_t = 0
                static var sharedInstance: ScoreManager? = nil
            }
            dispatch_once(&StaticInstance.onceToken, {
                StaticInstance.sharedInstance = ScoreManager()
                })
            return StaticInstance.sharedInstance!
        }
    }
    
    let apiBaseURL = NSURL(string:"https://api.hockeystreams.com/Scores?key=7344b5c9c89372d26b068022c9f28175&date=03/14/2014")

    //let apiBaseURL = NSURL(string:"https://api.hockeystreams.com/Scores?key=7344b5c9c89372d26b068022c9f28175")

    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
    
    var games = Game[]()
    
    func retrieveScores(completionClosure: (Game[], NSError?) -> ()) {
        let request = NSMutableURLRequest(URL: apiBaseURL)
        let task = urlSession.downloadTaskWithRequest(request, completionHandler: {
            (url, response, error) in
            
            if let errorOccurred = error {
                completionClosure(Game[](), error)
                return
            } else {
                var gameArray = Game[]()
                let data = NSData(contentsOfURL: url)
                var jsonError: NSError? = nil
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &jsonError)
                if let errorOccurred = error {
                    completionClosure(Game[](), error)
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
                completionClosure(gameArray, nil)
            }
            })
        task.resume()
    }
    
}

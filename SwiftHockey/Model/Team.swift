//
//  Team.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import Foundation

class Team {
    
    let cityName: String
    let teamName: String
    let shortName: String
    
    var fullName: String {
        get {
            return cityName + " " + teamName
        }
    }
    
    init(var cityName: String, teamName: String, var shortName: String) {
        
        if (cityName == "NY Rangers" || cityName == "NY Islanders") {
            cityName = "New York"
        }
        
//TODO: figure out why this broke in Beta 4
        
        if (shortName == "" && countElements(cityName) >= 3) {
            let cityString = cityName as NSString
            shortName = cityString.substringToIndex(3).uppercaseString
        }
        
        self.cityName = cityName
        self.teamName = teamName
        self.shortName = shortName
    }
    
}
//
//  Team.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import Foundation

public class Team {
    
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
        
        if (count(shortName) == 0) {
            shortName = cityName[cityName.startIndex..<advance(cityName.startIndex, 3, cityName.endIndex)]
        }
        
        self.cityName = cityName
        self.teamName = teamName
        self.shortName = shortName.uppercaseString
    }
    
}
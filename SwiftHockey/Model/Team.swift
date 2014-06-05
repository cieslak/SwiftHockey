//
//  Team.swift
//  SwiftHockey
//
//  Created by Chris Cieslak on 6/3/14.
//  Copyright (c) 2014 Electropuf. All rights reserved.
//

import Foundation

class Team {
    
    var cityName: String
    var teamName: String
    var shortName: String
    
    var fullName: String {
        get {
            return cityName + " " + teamName
        }
    }
    
    init(cityName: String, teamName: String, shortName: String) {
        self.cityName = cityName
        self.teamName = teamName
        self.shortName = shortName
    }
    
}
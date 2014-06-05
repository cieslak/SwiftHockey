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
    
    init(cityName: String, teamName: String, shortName: String) {
        self.cityName = cityName
        self.teamName = teamName
        self.shortName = shortName
    }
    
}
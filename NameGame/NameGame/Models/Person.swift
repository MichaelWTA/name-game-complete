//
//  Person.swift
//  NameGame
//
//  Created by Erik LaManna on 11/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var jobTitle: String?
    var headshot: Headshot?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

func == (lhs: Profile, rhs: Profile) -> Bool {
    return lhs.id == rhs.id
}

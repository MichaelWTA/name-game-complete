//
//  Headshot.swift
//  NameGame
//
//  Created by Jeff Ward on 2/21/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

struct Headshot: Codable {
    var id: String
    var type: String
    var url: String?
    var alt: String
    var width: Int?
    var height: Int?
}

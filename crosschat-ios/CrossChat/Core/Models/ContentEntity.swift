//
//  ContentEntity.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/10/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

enum ContentEntityType: String, Codable {
    case mention
    case emoticon
    case url
}

struct ContentEntity: Codable {
    var start: Int
    var end: Int
    var value: String
    var type: ContentEntityType
}

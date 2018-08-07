//
//  ParsedMessage.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/10/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

struct ParsedMessage: Codable {
    
    var rawMessage: String? = nil
    var mentions: [String]? = nil
    var emoticons: [String]? = nil
    var links: [String]? = nil
    var allEntities: [ContentEntity]? = nil
    
    private enum CodingKeys: String, CodingKey {
        case mentions
        case emoticons
        case links
    }
}

extension ParsedMessage: CustomStringConvertible {
    var description: String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        if let jsonString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") {
            return jsonString
        }
        return "error"
    }
}

//
//  ChatMessageItem.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/11/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

enum MessageType: String, Codable {
    case Mine
    case Reply
}

enum MessageFormat: String, Codable {
    case PlainText
    case RichText
    case Html
}

struct ChatMessageItem: CustomStringConvertible, Codable {
    
    var parsedMessage: ParsedMessage?
    var message: String?
    var date: Date?
    var type: MessageType?
    var format: MessageFormat?
    
    public var description: String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        if let jsonString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") {
            return jsonString
        }
        return "error"
    }
}

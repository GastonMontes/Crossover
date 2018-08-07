//
//  ChatManager.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/12/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

class ChatManager {
    
    static func analyseChatMessage(of text: String?, completion: @escaping (_ parsedMessage: ParsedMessage?) -> Void) {
        
        DispatchQueue.global().async {
            do {
                let allExtractedEntities = try ContentAnalyser.extractEntitiesWithIndices(from: text)
                
                let extractedMentions = allExtractedEntities
                    .filter { (entity) -> Bool in
                        return entity.type == .Mention
                    }
                    .map { (entity) -> String in
                        return entity.value
                }
                
                let extractedEmoticons = allExtractedEntities
                    .filter { (entity) -> Bool in
                        return entity.type == .Emoticon
                    }
                    .map { (entity) -> String in
                        return entity.value
                }
                
                let extractedLinks = allExtractedEntities
                    .filter { (entity) -> Bool in
                        return entity.type == .Url
                    }
                    .map { (entity) -> String in
                        return entity.value
                }
                
                var parsedMessage = ParsedMessage()
                
                parsedMessage.rawMessage = text
                if (!extractedMentions.isEmpty) {
                    parsedMessage.mentions = extractedMentions
                }
                if (!extractedEmoticons.isEmpty) {
                    parsedMessage.emoticons = extractedEmoticons
                }
                if (!extractedLinks.isEmpty) {
                    parsedMessage.links = extractedLinks
                }
                parsedMessage.allEntities = allExtractedEntities
                
                DispatchQueue.main.sync {
                    completion(parsedMessage)
                }
            } catch let error {
                debugPrint(error)
                DispatchQueue.main.sync {
                    completion(nil)
                }
            }
        }
    }
}

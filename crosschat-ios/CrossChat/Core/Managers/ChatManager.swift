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
                    .filter { $0.type == .mention }
                    .map { $0.value }
                
                let extractedEmoticons = allExtractedEntities
                    .filter { $0.type == .emoticon }
                    .map { $0.value }
                
                let extractedLinks = allExtractedEntities
                    .filter { $0.type == .url }
                    .map { $0.value }
                
                let extractedHashtags = allExtractedEntities
                    .filter { $0.type == .hashtag }
                    .map { $0.value }
                
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
                
                if (!extractedHashtags.isEmpty) {
                    parsedMessage.hashtags = extractedHashtags
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

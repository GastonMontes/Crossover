//
//  String+ChatMessage.swift
//  CrossChat
//
//  Created by Gaston  Montes on 05/02/2019.
//  Copyright © 2019 Crossover. All rights reserved.
//

import Foundation

extension String {
    static func stringGetWelcomeMessage() -> ChatMessageItem {
        var welcomeChatMessage = ChatMessageItem()
        welcomeChatMessage.message = NSLocalizedString("welcome_message", comment: "")
        welcomeChatMessage.type = .reply
        welcomeChatMessage.format = .html
        welcomeChatMessage.date = Date()
        return welcomeChatMessage
    }
    
    func stringGetSelfChatMesage() -> ChatMessageItem {
        var selfMessage = ChatMessageItem()
        selfMessage.message = self
        selfMessage.type = .mine
        selfMessage.format = .plainText
        selfMessage.date = Date()
        
        return selfMessage
    }
    
    func stringGetJSONChatMessage(completion: @escaping (_ chatMessageItem: ChatMessageItem?) -> Void) {
        guard self.count > 0 else {
            completion(nil)
            return
        }
        
        ChatManager.analyseChatMessage(of: self, completion: { parsedMessage in
            guard let parsedMessageDescription = parsedMessage?.parsedDescription, parsedMessageDescription.count > 0 else {
                completion(nil)
                return
            }
            
            var JSONMessage = ChatMessageItem()
            JSONMessage.type = .reply
            JSONMessage.format = .plainText
            JSONMessage.date = Date()
            JSONMessage.message = parsedMessageDescription
            completion(JSONMessage)
        })
    }
    
    func stringGetReplyChatMessage(completion: @escaping (_ chatMessageItem: ChatMessageItem?) -> Void) {
        guard self.count > 0 else {
            completion(nil)
            return
        }
        
        ChatManager.analyseChatMessage(of: self, completion: { parsedMessage in
            guard let entities = parsedMessage?.allEntities, entities.count > 0 else {
                completion(nil)
                return
            }
            
            var replyMessage = ChatMessageItem()
            replyMessage.parsedMessage = parsedMessage
            replyMessage.type = .reply
            replyMessage.format = .richText
            replyMessage.date = Date()
            completion(replyMessage)
        })
    }
}

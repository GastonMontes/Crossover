//
//  String+ChatMessage.swift
//  CrossChat
//
//  Created by Gaston  Montes on 05/02/2019.
//  Copyright © 2019 Crossover. All rights reserved.
//

import Foundation

extension String {
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
            if let parsedMessageDescription = parsedMessage?.parsedDescription, parsedMessageDescription.count > 0 {
                var JSONMessage = ChatMessageItem()
                JSONMessage.type = .reply
                JSONMessage.format = .plainText
                JSONMessage.date = Date()
                JSONMessage.message = parsedMessageDescription
                completion(JSONMessage)
            } else {
                completion(nil)
            }
        })
    }
}

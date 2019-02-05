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
        
        return selfMessage;
    }
}

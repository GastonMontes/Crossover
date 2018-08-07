//
//  ChatActions.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/11/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

protocol ChatActions {
    func onWelcomeMessageRequested()
    
    func onChatMessageSubmitted(messageText: String)
}

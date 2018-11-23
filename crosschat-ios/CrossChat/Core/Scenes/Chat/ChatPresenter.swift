//
//  ChatPresenter.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/11/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

class ChatPresenter: BasePresenter<ChatView>, ChatActions {
    
    var chatMessageItems = [ChatMessageItem]()
    
    override init() {
        super.init()
    }
    
    func onWelcomeMessageRequested() {
        if (!chatMessageItems.isEmpty) {
            return
        }
        
        var welcomeChatMessage = ChatMessageItem()
        welcomeChatMessage.message = NSLocalizedString("welcome_message", comment: "")
        welcomeChatMessage.type = .reply
        welcomeChatMessage.format = .html
        welcomeChatMessage.date = Date()
        
        addChatMessage(welcomeChatMessage)
    }
    
    func onChatMessageSubmitted(messageText: String) {
        view?.startLoading()
        addSelfMessage(of: messageText)
        analyseChatMessage(of: messageText, completion: {
            [weak self] () -> Void in
            self?.view?.finishLoading()
        })
    }
    
    func addSelfMessage(of text: String) {
        var selfMessage = ChatMessageItem()
        selfMessage.message = text
        selfMessage.type = .mine
        selfMessage.format = .plainText
        selfMessage.date = Date()
        
        addChatMessage(selfMessage)
    }
    
    func addReplyMessage(_ parsedMessage: ParsedMessage?) {
        var replyMessage = ChatMessageItem()
        if let parsedMessage = parsedMessage {
            replyMessage.message = parsedMessage.description
            replyMessage.parsedMessage = parsedMessage
        } else {
            replyMessage.message = "msg_failed_processing_message"
        }
        replyMessage.type = .reply
        replyMessage.format = .plainText
        replyMessage.date = Date()
    
        addChatMessage(replyMessage)
        addReplyFormattedMessage(replyMessage)
    }
    
    func addFailureReplyMessage() {
        addReplyMessage(nil)
    }
    
    func addReplyFormattedMessage(_ chatMessage: ChatMessageItem?) {
        guard let parsedMessage = chatMessage?.parsedMessage else {
            return
        }
        
        if parsedMessage.allEntities?.isEmpty ?? true {
            return
        }
    
        var replyFormattedMessage = ChatMessageItem()
        replyFormattedMessage.parsedMessage = parsedMessage
        replyFormattedMessage.type = .reply
        replyFormattedMessage.format = .richText
        replyFormattedMessage.date = Date()
    
        addChatMessage(replyFormattedMessage)
    }
    
    private func addChatMessage(_ chatMessage: ChatMessageItem?) {
        guard let chatMessage = chatMessage else {
            return
        }
    
        chatMessageItems.append(chatMessage)
        
        view?.updateChatView()
    }
    
    private func analyseChatMessage(of text: String, completion: @escaping () -> Void) {
        ChatManager.analyseChatMessage(of: text, completion: {
            [weak self] (parsedMessage) -> Void in
            if let parsedMessage = parsedMessage {
                self?.addReplyMessage(parsedMessage)
            } else {
                self?.addFailureReplyMessage()
            }
            
            completion()
        })
    }
}

//
//  TextUtils.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/12/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation
import UIKit

class TextUtils {
    public static func getFormattedText(of parsedMessage: ParsedMessage?) -> NSAttributedString {
        guard let parsedMessage = parsedMessage, let rawMessage = parsedMessage.rawMessage else {
            return NSAttributedString()
        }
        
        let attributedString = NSMutableAttributedString(string: rawMessage)
        
        if let allEntities = parsedMessage.allEntities {
            for entity in allEntities {
                switch entity.type {
                    
                case .Mention:
                    attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSMakeRange(entity.start, entity.end - entity.start))
                    break
                case .Emoticon:
                    attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSMakeRange(entity.start, entity.end - entity.start))
                case .Url:
                    attributedString.addAttribute(.foregroundColor, value: UIColor.magenta, range: NSMakeRange(entity.start, entity.end - entity.start))
                }
            }
        }
        
        return attributedString
    }
}

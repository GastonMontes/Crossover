//
//  ContentAnalyser.swift
//  CrossChat
//
//  Created by Mahmoud Abdurrahman on 7/11/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import Foundation

class ContentAnalyser {
    
    /**
     * Extract @mentions, {emoticons}, and URLs from a given message text.
     * @param text text of message
     * @return list of extracted entities values
     */
    static func extractEntities(from text: String?) throws -> [String] {
        let entities = try? extractEntitiesWithIndices(from: text)
        
        return entities?.map { $0.value } ?? []
    }
    
    /**
     * Extract @mentions, {emoticons}, and URLs from a given message text.
     * @param text text of message
     * @return list of extracted entities
     */
    static func extractEntitiesWithIndices(from text: String?) throws -> [ContentEntity] {
        var entities = [ContentEntity]()
        
        do {
            try entities.append(contentsOf: extractMentionsWithIndices(from: text))
            try entities.append(contentsOf: extractEmoticonsWithIndices(from: text))
            try entities.append(contentsOf: extractURLsWithIndices(from: text))
            try entities.append(contentsOf: extractHashtagWithIndices(from: text))
        } catch let error {
            throw error
        }
        
        return entities.removeOverlapping()
    }
    
    /**
     * Extract @mention references from a given text. A mention is an occurrence
     * of @mention anywhere in a message text.
     *
     * @param text of the message from which to extract mentions
     * @return List of mentions referenced (without the leading @ sign)
     */
    static func extractMentions(from text: String?) throws -> [String] {
        guard let text = text else {
            return []
        }
        let entities = try? extractMentionsWithIndices(from: text)
        
        return entities?.map { $0.value } ?? []
    }

    /**
     * Extract @mention references from a given text. A mention is an occurrence of
     * @mention anywhere in a message text.
     *
     * @param text of the message from which to extract mentions
     * @return List of {@link ContentEntity} of type {@link ContentEntityType}, having
     * info about start index, end index, and value of the referenced mention (without the leading
     * @ sign)
     */
    static func extractMentionsWithIndices(from text: String?) throws -> [ContentEntity] {
        guard let text = text else {
            return []
        }
        
        // Performance optimization.
        // If text doesn't contain @ at all, the text doesn't
        // contain @mention. So we can simply return an empty list.
        if (text.isEmpty || !text.contains("@")) {
            return []
        }
        var extracted = [ContentEntity]()
        let matches = ContentRegex.VALID_MENTION.matches(in: text,
                                                         range: NSMakeRange(0, text.utf16.count))
        for match in matches {
            if (match.numberOfRanges < ContentRegex.VALID_MENTION_GROUP_USERNAME + 1) {
                continue
            }
            
            // Getting mentioned username
            let usernameRange = match.range(at: ContentRegex.VALID_MENTION_GROUP_USERNAME)
            if usernameRange.location == NSNotFound || usernameRange.length == 0 {
                continue
            }
            
            let usernameStart = String.UTF16Index(encodedOffset: usernameRange.lowerBound)
            let usernameEnd = String.UTF16Index(encodedOffset: usernameRange.upperBound)
            
            let username = String(text.utf16[usernameStart..<usernameEnd])!
            
            // Getting the full pattern start/end
            let atCharacterRange = match.range(at: ContentRegex.VALID_MENTION_GROUP_AT)
            
            let start = String.UTF16Index(encodedOffset: atCharacterRange.lowerBound)
            let end = String.UTF16Index(encodedOffset: usernameRange.upperBound)
            
            let mentionEntity = ContentEntity(start: start.encodedOffset, end: end.encodedOffset, value: username, type: .mention)
            extracted.append(mentionEntity)
        }
        
        return extracted
    }
    
    /**
     * Extract (emoticons) references from a given text. An emoticon is an occurrence of (emoticon)
     * anywhere in a message text.
     *
     * @param text of the message from which to extract emoticons
     * @return List of emoticons referenced (without the wrapping () parentheses)
     */
    static func extractEmoticons(from text: String?) throws -> [String] {
        guard let text = text else {
            return []
        }
        let entities = try? extractEmoticonsWithIndices(from: text)
        
        return entities?.map { $0.value } ?? []
    }
    
    /**
     * Extract (emoticons) references from a given text. An emoticon is an occurrence of (emoticon)
     * anywhere in a message text.
     *
     * @param text of the message from which to extract emoticons
     * @return List of {@link ContentEntity} of type {@link ContentEntity.Type#EMOTICON}, having
     * info about start index, end index, and value of the referenced emoticon (without the wrapping
     * () parentheses)
     */
    static func extractEmoticonsWithIndices(from text: String?) throws -> [ContentEntity] {
        guard let text = text else {
            return []
        }
    
        // Performance optimization.
        // If text doesn't contain both ( and ) at all, the text doesn't
        // contain (emoticon). So we can simply return an empty list.
        if (text.isEmpty || !text.contains("(") || !text.contains(")")) {
            return []
        }
    
        var extracted = [ContentEntity]()
        let matches = ContentRegex.VALID_EMOTICON.matches(in: text,
                                                         range: NSMakeRange(0, text.utf16.count))
        for match in matches {
            if (match.numberOfRanges < ContentRegex.VALID_EMOTICON_GROUP_RIGHT_PAREN + 1) {
                continue
            }
            
            let emoticonRange = match.range(at: ContentRegex.VALID_EMOTICON_GROUP_VALUE)
            let leftParenRange = match.range(at: ContentRegex.VALID_EMOTICON_GROUP_LEFT_PAREN)
            let rightParenRange = match.range(at: ContentRegex.VALID_EMOTICON_GROUP_RIGHT_PAREN)
            
            let emoticonStart = String.UTF16Index(encodedOffset: emoticonRange.lowerBound)
            let emoticonEnd = String.UTF16Index(encodedOffset: emoticonRange.upperBound)
            
            let start = String.UTF16Index(encodedOffset: leftParenRange.lowerBound)
            let end = String.UTF16Index(encodedOffset: rightParenRange.upperBound)
            
            let emoticon = String(text.utf16[emoticonStart..<emoticonEnd])!
            
            let emoticonEntity = ContentEntity(start: start.encodedOffset, end: end.encodedOffset, value: emoticon, type: .emoticon)
            extracted.append(emoticonEntity)
        }
        
        return extracted
    }
    
    /**
     * Extract URL references from a given text.
     *
     * @param text of the message from which to extract URLs
     * @return List of URLs referenced.
     */
    static func extractURLs(from text: String?) throws -> [String] {
        guard let text = text else {
            return []
        }
        let entities = try? extractURLsWithIndices(from: text)
        
        return entities?.map { $0.value } ?? []
    }
    
    /**
     * Extract URL references from a given text.
     *
     * @param text of the message from which to extract URLs
     * @return List of {@link ContentEntity} of type {@link ContentEntity.Type#URL}, having info
     *  about start index, end index, and value of the referenced URL
     */
    static func extractURLsWithIndices(from text: String?) throws -> [ContentEntity] {
        guard let text = text else {
            return []
        }
        
        // Performance optimization.
        // If text doesn't contain '.' at all, text doesn't contain URL,
        // so we can simply return an empty list.
        if (text.isEmpty || !text.contains(".")) {
            return []
        }
        
        var extracted = [ContentEntity]()
        let matches = ContentRegex.VALID_URL.matches(in: text,
                                                          range: NSMakeRange(0, text.utf16.count))
        
        for match in matches {
            // skip if URL has no protocol and is preceded by invalid character.
            let protocolRange = match.range(at: ContentRegex.VALID_URL_GROUP_PROTOCOL)
            if protocolRange.location == NSNotFound {
                let beforeUrlRange = match.range(at: ContentRegex.VALID_URL_GROUP_BEFORE)
                
                let beforeUrlStart = String.UTF16Index(encodedOffset: beforeUrlRange.lowerBound)
                let beforeUrlEnd = String.UTF16Index(encodedOffset: beforeUrlRange.upperBound)
                
                let beforeUrl = String(text.utf16[beforeUrlStart..<beforeUrlEnd])!
                let invalidUrlBeginMatches = ContentRegex.INVALID_URL_WITHOUT_PROTOCOL_MATCH_BEGIN.matches(in: beforeUrl,
                                                                      range: NSMakeRange(0, beforeUrl.utf16.count))
                if invalidUrlBeginMatches.count > 0 {
                    continue
                }
            }
            
            let urlRange = match.range(at: ContentRegex.VALID_URL_GROUP_URL)
            
            let start = String.UTF16Index(encodedOffset: urlRange.lowerBound)
            let end = String.UTF16Index(encodedOffset: urlRange.upperBound)
            
            let url = String(text.utf16[start..<end])!
            
            let urlEntity = ContentEntity(start: start.encodedOffset, end: end.encodedOffset, value: url, type: .url)
            extracted.append(urlEntity)
        }
        
        return extracted
    }
    
    /**
     * Extract #hashtag references from a given text. A hashtag is an occurrence of
     * #hashtag anywhere in a message text.
     *
     * @param text of the message from which to extract mentions
     * @return List of {@link ContentEntity} of type {@link ContentEntityType}, having
     * info about start index, end index, and value of the referenced mention (without the leading
     * # sign)
     */
    static func extractHashtagWithIndices(from text: String?) throws -> [ContentEntity] {
        guard let text = text else {
            return []
        }
        
        // Performance optimization.
        // If text doesn't contain # at all, the text doesn't
        // contain #hashtag. So we can simply return an empty list.
        if (text.isEmpty || !text.contains("#")) {
            return []
        }
        
        var extracted = [ContentEntity]()
        let matches = ContentRegex.VALID_HASHTAG.matches(in: text, range: NSMakeRange(0, text.utf16.count))
        
        for match in matches {
            if (match.numberOfRanges < ContentRegex.VALID_HASHTAG_GROUP_WORD + 1) {
                continue
            }
            
            let hashtagWordRange = match.range(at: ContentRegex.VALID_HASHTAG_GROUP_WORD)
            if hashtagWordRange.location == NSNotFound || hashtagWordRange.length == 0 {
                continue
            }
            
            let hashtagWordStart = String.UTF16Index(encodedOffset: hashtagWordRange.lowerBound)
            let hashtagWordEnd = String.UTF16Index(encodedOffset: hashtagWordRange.upperBound)
            
            let hashtag = String(text.utf16[hashtagWordStart..<hashtagWordEnd])!
            
            let atHashtagCharacterRange = match.range(at: ContentRegex.VALID_HASHTAG_GROUP_AT)
            
            let start = String.UTF16Index(encodedOffset: atHashtagCharacterRange.lowerBound)
            let end = String.UTF16Index(encodedOffset: hashtagWordRange.upperBound)
            
            let mentionEntity = ContentEntity(start: start.encodedOffset, end: end.encodedOffset, value: hashtag, type: .hashtag)
            extracted.append(mentionEntity)
        }
        
        return extracted
    }
}

extension Array where Iterator.Element == ContentEntity {
    func removeOverlapping() -> [Element] {
        // if source array is empty or only has single element, then nothing to remove,
        // we just return self
        if (isEmpty || count == 1) {
            return self
        }
        
        // sort by start index asc
        let sorted = self.sorted {
            return $0.start < $1.start
        }
        
        // Remove overlapping entities.
        // Two entities overlap only when one is URL and the other is mention/emoticon
        // which is a part of the URL. When it happens, we choose URL over mention/emoticon
        // by selecting the one with smaller start index.
        var results = [ContentEntity]()
        
        var prev: ContentEntity?
        for (i, curr) in sorted.enumerated() {
            if i > 0 && prev?.end ?? -1 > curr.start {
                prev = curr
                continue
            }
            
            prev = curr
            results.append(curr)
        }
        
        return results
    }
}

//
//  ContentAnalyserAdvancedEntitiesTests.swift
//  CrossChatTests
//
//  Created by Mahmoud Abdurrahman on 7/12/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import XCTest

class ContentAnalyserAdvancedEntitiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEntitiesAllTogether() {
        let extracted = try! ContentAnalyser.extractEntities(from: "@bob @john (smile) The emoticon cheat-sheet to make you oh-so emoticon literate: https://t.co/ewYZty149a ")
        let expected = ["bob", "john", "smile", "https://t.co/ewYZty149a"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract full entities")
    }
    
    func testMentionOverlappingUrl() {
        let extracted = try! ContentAnalyser.extractEntities(from: "Here's an example of URL that overlaps with mention-like-keyword: http://example.com/@dave ")
        let expected = ["http://example.com/@dave"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract URL overlapping mention")
    }
    
    func testEmoticonOverlappingUrl() {
        let extracted = try! ContentAnalyser.extractEntities(from: "Here's an example of URL that overlaps an emoticon-like-pattern: http://example.com/test_(test) ")
        let expected = ["http://example.com/test_(test)"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract URL overlapping emoticon")
    }
    
    func testMentionAndEmoticonOverlappingUrl() {
        let extracted = try! ContentAnalyser.extractEntities(from: "Here's an example of URL that overlaps both mention-like-keyword and an emoticon-like-pattern: http://example.com/test_(test)/@dave ")
        let expected = ["http://example.com/test_(test)/@dave"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract URL overlapping both mention and emoticon")
    }
    
    func testMentionOverlappingEmoticon() {
        let extracted = try! ContentAnalyser.extractEntities(from: "Good morning! (@megusta) (@coffee)")
        let expected = ["megusta", "coffee"]
        
        XCTAssertEqual(extracted, expected, "Extracted invalid emoticons: \(extracted)")
    }
    
    func testEmailAddressShouldNotConsideredAsMention() {
        let extracted = try! ContentAnalyser.extractEntities(from: "Example of email address: username@somewhere.foo ")
        
        XCTAssertEqual(extracted.count, 0, "Extracted an invalid mention: \(extracted)")
    }
    
}

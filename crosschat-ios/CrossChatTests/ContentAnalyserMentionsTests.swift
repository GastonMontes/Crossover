//
//  ContentAnalyserMentionsTests.swift
//  CrossChatTests
//
//  Created by Mahmoud Abdurrahman on 7/12/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import XCTest

class ContentAnalyserMentionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMentionAtTheBeginning() {
        let extracted = try! ContentAnalyser.extractMentions(from: "@user mention")
        let expected = ["user"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract mention at the beginning")
    }
    
    func testMentionWithLeadingSpace() {
        let extracted = try! ContentAnalyser.extractMentions(from: " @user mention")
        let expected = ["user"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract mention with leading space")
    }
    
    func testMentionInMidText() {
        let extracted = try! ContentAnalyser.extractMentions(from: "mention @user here")
        let expected = ["user"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract mention in mid text")
    }
    
    func testMultipleMentions() {
        let extracted = try! ContentAnalyser.extractMentions(from: "mention @user1 here and @user2 here")
        let expected = ["user1", "user2"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract multiple mentioned users")
    }
    
    func testInvalidMention() {
        let extracted = try! ContentAnalyser.extractMentions(from: "@ invalid mention.")
        let expected: [String] = []
        
        XCTAssertEqual(extracted, expected,"Extracted an invalid mention: \(extracted)")
    }
    
    func testMentionWithIndices() {
        let extracted = try! ContentAnalyser.extractMentionsWithIndices(from:" @user1 mention @user2 here @user3 ")
        
        XCTAssertEqual(extracted.count, 3)
        XCTAssertEqual(extracted[0].start, 1)
        XCTAssertEqual(extracted[0].end, 7)
        XCTAssertEqual(extracted[1].start, 16)
        XCTAssertEqual(extracted[1].end, 22)
        XCTAssertEqual(extracted[2].start, 28)
        XCTAssertEqual(extracted[2].end, 34)
    }
}

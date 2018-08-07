//
//  ContentAnalyserEmoticonsTests.swift
//  CrossChatTests
//
//  Created by Mahmoud Abdurrahman on 7/12/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import XCTest

class ContentAnalyserEmoticonsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmoticonAtTheBeginning() {
        let extracted = try! ContentAnalyser.extractEmoticons(from: "(smile) emoticon")
        let expected = ["smile"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract emoticon at the beginning")
    }
    
    func testEmoticonWithLeadingSpace() {
        let extracted = try! ContentAnalyser.extractEmoticons(from: " (smile) emoticon")
        let expected = ["smile"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract emoticon with leading space")
    }
    
    func testEmoticonInMidText() {
        let extracted = try! ContentAnalyser.extractEmoticons(from: "emoticon (smile) here")
        let expected = ["smile"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract emoticon in mid text")
    }
    
    func testMultipleEmoticons() {
        let extracted = try! ContentAnalyser.extractEmoticons(from: "emoticon (smile) and (anger)")
        let expected = ["smile", "anger"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract multiple emoticons")
    }
    
    func testInvalidEmoticons() {
        let extracted = try! ContentAnalyser.extractEmoticons(from: "Good morning! () (@coffee) (a) (challengeaccepted) (crossover)")
        let expected = ["a", "crossover"]
        
        XCTAssertEqual(extracted, expected, "Extracted invalid emoticons: \(extracted)")
    }
    
    func testEmoticonWithIndices() {
        let extracted = try! ContentAnalyser.extractEmoticonsWithIndices(from: " (smile) and (anger) and (sad) are all emoticons ")
        
        XCTAssertEqual(extracted.count, 3)
        XCTAssertEqual(extracted[0].start, 1)
        XCTAssertEqual(extracted[0].end, 8)
        XCTAssertEqual(extracted[1].start, 13)
        XCTAssertEqual(extracted[1].end, 20)
        XCTAssertEqual(extracted[2].start, 25)
        XCTAssertEqual(extracted[2].end, 30)
    }
    
}

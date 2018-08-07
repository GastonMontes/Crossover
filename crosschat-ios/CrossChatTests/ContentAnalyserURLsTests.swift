//
//  ContentAnalyserURLsTests.swift
//  CrossChatTests
//
//  Created by Mahmoud Abdurrahman on 7/12/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import XCTest

class ContentAnalyserURLsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUrlWithIndices() {
        let extracted = try! ContentAnalyser.extractURLsWithIndices(from: "https://goo.gl/omqXF0 url https://www.crossover.com ")
        
        XCTAssertEqual(extracted.count, 2)
        XCTAssertEqual(extracted[0].start, 0)
        XCTAssertEqual(extracted[0].end, 21)
        XCTAssertEqual(extracted[1].start, 26)
        XCTAssertEqual(extracted[1].end, 51)
    }
    
    func testURLFollowedByPunctuations() {
        let extracted = try! ContentAnalyser.extractURLs(from: "http://games.aarp.org/games/mahjongg-dimensions.aspx!!!!!!")
        let expected = ["http://games.aarp.org/games/mahjongg-dimensions.aspx"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract URLs followed by punctuations")
    }
    
    func testUrlWithPunctuation() {
        let urls = [
            "http://www.foo.com/foo/path-with-period./",
            "http://www.foo.org.za/foo/bar/688.1",
            "http://www.foo.com/bar-path/some.stm?param1=fooparam2=P1|0||P2|0",
            "http://foo.com/bar/123/foo_&_bar/",
            "http://foo.com/bar(test)bar(test)bar(test)",
            "www.foo.com/foo/path-with-period./",
            "www.foo.org.za/foo/bar/688.1",
            "www.foo.com/bar-path/some.stm?param1=fooparam2=P1|0||P2|0",
            "foo.com/bar/123/foo_&_bar/"
        ]
        
        for url in urls {
            let extracted = try! ContentAnalyser.extractURLs(from: url)
            
            XCTAssertEqual(extracted.count, 1)
            XCTAssertEqual(url, extracted[0])
        }
    }
    
}

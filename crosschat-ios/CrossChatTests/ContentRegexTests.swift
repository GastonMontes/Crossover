//
//  ContentRegexTests.swift
//  CrossChatTests
//
//  Created by Mahmoud Abdurrahman on 7/13/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import XCTest

class ContentRegexTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMentionsRegex() {
        assertCaptureCount(3, ContentRegex.VALID_MENTION, "@username")
    }
    
    func testExtractMentions() {
        assertCaptureCount(3, ContentRegex.VALID_MENTION, "sample @user mention")
    }
    
    func testInvalidMentions() {
        let invalidChars = "!@#$%&*"
        for char in invalidChars {
            let stringToTest = "f\(char)@kn"
            assertRegexFalse(ContentRegex.VALID_MENTION, stringToTest, "Failed to ignore a mention preceded by \(char)")
        }
    }
    
    func testEmoticonsRegex() {
        assertCaptureCount(3, ContentRegex.VALID_EMOTICON, "(emoticon)")
    }
    
    func testExtractEmoticons() {
        assertCaptureCount(3, ContentRegex.VALID_EMOTICON, "sample (emoticon) within message")
    }
    
    func testValidURL() {
        assertCaptureCount(8, ContentRegex.VALID_URL, "http://example.com")
        assertCaptureCount(8, ContentRegex.VALID_URL, "http://はじめよう.みんな")
        assertCaptureCount(8, ContentRegex.VALID_URL, "http://はじめよう.香港")
        assertCaptureCount(8, ContentRegex.VALID_URL, "http://はじめよう.الجزائر")
        assertCaptureCount(8, ContentRegex.VALID_URL, "http://test.scot")
    }
    
    func testValidURLDoesNotCrashOnLongPaths() {
        let longPathIsLong =
        """
Check out http://example.com/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
"""
        
        assertRegexTrue(ContentRegex.VALID_URL, longPathIsLong, "Failed to correctly match a very long path")
    }
    
    func testValidUrlDoesNotTakeForeverOnRepeatedPunctuationAtEnd() {
        let repeatedPaths = [
            "Try http://example.com/path**********************",
            "http://foo.org/bar/foo-bar-foo-bar.aspx!!!!!! Test"
        ]
        
        for text in repeatedPaths {
            let numRuns = 100
            let interval = timeBlockWithMach {
                for _ in 0..<numRuns {
                    ContentRegex.VALID_URL.matches(in: text, range: NSMakeRange(0, text.utf16.count))
                }
            }
            let isValid = ContentRegex.VALID_URL.rangeOfFirstMatch(in: text, range: NSMakeRange(0, text.utf16.count)).location != NSNotFound
            
            XCTAssertTrue(isValid, "Should be able to extract a valid URL even followed by punctuations")
            
            XCTAssertTrue(interval < Double(10 * numRuns), "Matching a repeated path end should take less than 10ms (took \(interval / Double(numRuns))ms)")
        }
    }
    
    func testValidURLWithoutProtocol() {
        
        assertRegexTrue(ContentRegex.VALID_URL, "twitter.com", "Matching a URL with gTLD without protocol.")
        assertRegexTrue(ContentRegex.VALID_URL, "www.foo.co.jp", "Matching a URL with ccTLD without protocol.")
        assertRegexTrue(ContentRegex.VALID_URL, "www.foo.org.za", "Matching a URL with gTLD followed by ccTLD without protocol.")
        assertRegexTrue(ContentRegex.VALID_URL, "http://t.co", "Should match a short URL with ccTLD with protocol.")
        assertRegexFalse(ContentRegex.VALID_URL, "it.so", "Should not match a short URL with ccTLD without protocol.")
        assertRegexFalse(ContentRegex.VALID_URL, "www.xxxxxxx.baz", "Should not match a URL with invalid gTLD.")
        assertRegexTrue(ContentRegex.VALID_URL, "t.co/blahblah", "Match a short URL with ccTLD and '/' but without protocol.")
    }
    
    func testValidUrlDoesNotOverflowOnLongDomains() {
        let domainIsLong = """
cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool.cool
"""
        assertRegexTrue(ContentRegex.VALID_URL, domainIsLong, "Match a super long url")
    }
    
    func testInvalidUrlWithInvalidCharacter() {
        let invalidChars = "\u{202A}\u{202B}\u{202C}\u{202D}\u{202E}"
        for char in invalidChars {
            assertRegexFalse(ContentRegex.VALID_URL, "http://twitt\(char)er.com", "Should not extract URLs with invalid character: \(char)")
        }
    }
    
    private func assertRegexTrue(_ pattern: NSRegularExpression, _ sample: String, _ message: String) {
        let firstMatchRange = pattern.rangeOfFirstMatch(in: sample, range: NSMakeRange(0, sample.utf16.count))
        XCTAssertTrue(firstMatchRange.location != NSNotFound, message)
    }
    
    private func assertRegexFalse(_ pattern: NSRegularExpression, _ sample: String, _ message: String) {
        let firstMatchRange = pattern.rangeOfFirstMatch(in: sample, range: NSMakeRange(0, sample.utf16.count))
        XCTAssertFalse(firstMatchRange.location != NSNotFound, message)
    }
    
    private func assertCaptureCount(_ expectedCount: Int, _ pattern: NSRegularExpression, _ sample: String) {
        let matches = pattern.matches(in: sample, range: NSMakeRange(0, sample.utf16.count))
        let firstMatchRange = pattern.rangeOfFirstMatch(in: sample, range: NSMakeRange(0, sample.utf16.count))
        
        XCTAssertTrue(firstMatchRange.location != NSNotFound, "Pattern failed to match sample: \(sample)")
        XCTAssertEqual(expectedCount, matches[0].numberOfRanges - 1, "Does not have \(expectedCount) captures as expected: \(matches[0].numberOfRanges - 1)")
    }
    
    private func timeBlockWithMach(_ block: () -> Void) -> TimeInterval {
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }
        
        let start = mach_absolute_time()
        //Block execution to time!
        block()
        let end = mach_absolute_time()
        
        let elapsed = end - start
        
        let nanos = elapsed * UInt64(info.numer) / UInt64(info.denom)
        return TimeInterval(nanos) / TimeInterval(NSEC_PER_SEC)
    }
    
}

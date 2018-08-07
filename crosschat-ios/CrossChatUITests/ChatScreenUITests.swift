//
//  ChatScreenUITests.swift
//  CrossChatUITests
//
//  Created by Mahmoud Abdurrahman on 7/14/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import XCTest

class ChatScreenUITests: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIDevice.shared.orientation = .portrait
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIntroScreenHasProperUIElements() {
        app.buttons["LET'S START"].tap()
        
        XCTAssert(app.navigationBars["Chat Room"].exists)
        XCTAssert(app.tables["Chat table view"].exists)
        XCTAssert(app.textViews["Message text view"].exists)
        XCTAssert(app.buttons["Send"].exists)
    }
    
    func testWelcomeMessage() {
        app.buttons["LET'S START"].tap()
        
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["Hi, Welcome to CrossChat Message Analyser…\n\nLet's have a deal, first you send me a message and I promise to analyse its content the best I can, then I will reply with all my findings as soon as I finish.\n\nIf there're findings I will reply with a JSON object plus a nicely formatted message, otherwise, I will reply only with an empty JSON.\n\nI'm waiting for your messages… ;)"].exists)
    }
    
    func testSendButtonPressStateChangesOnMessage() {
        app.buttons["LET'S START"].tap()
        
        let textView = app.textViews["Message text view"]
        XCTAssert(textView.exists)
        
        XCTAssert(app.buttons["Send"].exists)
        XCTAssert(!app.buttons["Send"].isHittable)
        
        textView.tap()
        textView.typeText("Hello message")
        XCTAssert(app.buttons["Send"].isHittable)
    }
    
    func testMessageWithNoEntities() {
        app.buttons["LET'S START"].tap()
        
        let textView = app.textViews["Message text view"]
        textView.tap()
        textView.typeText("Hello message, it should have no entities")
        app.buttons["Send"].tap()
        
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts["Hello message, it should have no entities"].exists)
        XCTAssert(tablesQuery.children(matching: .cell).element(boundBy: 2).staticTexts["{}"].exists)
    }
    
    func testMessageWithDefaultText() {
        app.buttons["LET'S START"].tap()
        
        let textView = app.textViews["Message text view"]
        textView.tap()
        textView.typeText("@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016")
        app.buttons["Send"].tap()
        
        let tablesQuery = app.tables
        let secondCell = tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts["@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"]
        XCTAssert(secondCell.exists && secondCell.isHittable)
        
        let thirdCell = tablesQuery.children(matching: .cell).element(boundBy: 2).staticTexts["{\"emoticons\":[\"success\"],\"links\":" +
            "[\"https://twitter.com/jdorfman/status/430511497475670016\"]," +
            "\"mentions\":[\"bob\",\"john\"]}"]
        XCTAssert(thirdCell.exists && thirdCell.isHittable)
        
        let fourthCell = tablesQuery.children(matching: .cell).element(boundBy: 3).staticTexts["@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"]
        XCTAssert(fourthCell.exists && fourthCell.isHittable)
    }
    
    func testMessageWithDefaultTextWithSwitchingToLandscape() {
        app.buttons["LET'S START"].tap()
        
        //XCUIDevice.shared.orientation = .portrait
        
        let textView = app.textViews["Message text view"]
        textView.tap()
        textView.typeText("@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016")
        app.buttons["Send"].tap()
        
        let tablesQuery = app.tables
        let secondCell = tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts["@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"]
        XCTAssert(secondCell.exists && secondCell.isHittable)
        
        let thirdCell = tablesQuery.children(matching: .cell).element(boundBy: 2).staticTexts["{\"emoticons\":[\"success\"],\"links\":" +
            "[\"https://twitter.com/jdorfman/status/430511497475670016\"]," +
            "\"mentions\":[\"bob\",\"john\"]}"]
        XCTAssert(thirdCell.exists && thirdCell.isHittable)
        
        let fourthCell = tablesQuery.children(matching: .cell).element(boundBy: 3).staticTexts["@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"]
        XCTAssert(fourthCell.exists && fourthCell.isHittable)
        
        XCUIDevice.shared.orientation = .landscapeLeft
        // "Wait" for rotation to complete
        Thread.sleep(forTimeInterval: 1)
        
        XCTAssert(secondCell.exists && secondCell.isHittable)
        XCTAssert(thirdCell.exists && thirdCell.isHittable)
        XCTAssert(fourthCell.exists && fourthCell.isHittable)
    }
    
    func testTableviewScrolledToBottomOnNewMessage() {
        app.buttons["LET'S START"].tap()
        
        let textView = app.textViews["Message text view"]
        let tablesQuery = app.tables
        
        for i in 1..<11 {
            textView.tap()
            textView.typeText("Message \(i), (emoticon\(i))")
            app.buttons["Send"].tap()
        }
        
        let lastSelfCell = tablesQuery.children(matching: .cell).staticTexts["Message 10, (emoticon10)"].firstMatch
        XCTAssert(lastSelfCell.exists && lastSelfCell.isHittable)
        
        let lastReplyCell = tablesQuery.children(matching: .cell).staticTexts["{\"emoticons\":[\"emoticon10\"]}"].firstMatch
        XCTAssert(lastReplyCell.exists && lastReplyCell.isHittable)
    }
    
}

//
//  CrossChatUITests.swift
//  CrossChatUITests
//
//  Created by Mahmoud Abdurrahman on 7/10/18.
//  Copyright © 2018 Crossover. All rights reserved.
//

import XCTest

class IntroScreenUITests: XCTestCase {
    
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
        XCTAssert(app.images["Application welcome image"].exists)
        XCTAssert(app.staticTexts["Welcome to CrossChat Message Analyser."].exists)
        XCTAssert(app.staticTexts["Let me first introduce my self, I'm the magician behind CrossChat app, I can help you analyse your chat messages."].exists)
        XCTAssert(app.buttons["LET'S START"].exists)
        XCTAssert(app.buttons["LET'S START"].isHittable)
    }
    
    func testTappingLetsStartButtonOpendsNextScreen() {
        app.buttons["LET'S START"].tap()
        XCTAssert(app.navigationBars["Chat Room"].exists)
    }
    
}

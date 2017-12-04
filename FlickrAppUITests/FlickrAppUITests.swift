//
//  FlickrAppUITests.swift
//  FlickrAppUITests
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import XCTest

class FlickrAppUITests : XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        self.continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFeeds() {
        let app:XCUIApplication! = XCUIApplication()
        app.swipeDown()

        app.collectionViews.cells.otherElements.element(boundBy: 0).tap()

        let currentNavigationBar:XCUIElement! = app.navigationBars.element(boundBy: 0)
        XCTAssertTrue(currentNavigationBar.identifier.hasPrefix("1 of "))
    }

    func testSearch() {
        let app:XCUIApplication! = XCUIApplication()

        app.navigationBars["Popular Feeds"].buttons["Search"].tap()

        let pullToRefreshTable:XCUIElement! = app.tables.element(boundBy: 0)
        pullToRefreshTable.children(matching: XCUIElementType.searchField).element.tap()
        pullToRefreshTable.children(matching: XCUIElementType.searchField).element.typeText("Kittens\n")

        app.swipeDown()

        app.collectionViews.cells.otherElements.element(boundBy: 0).tap()
        let currentNavigationBar:XCUIElement! = app.navigationBars.element(boundBy: 0)
        self.waitForElementToAppear(element: currentNavigationBar)
        XCTAssertTrue(currentNavigationBar.identifier.hasPrefix("1 of "))
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
}

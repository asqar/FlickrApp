//
//  FlickrAppUITests.m
//  FlickrAppUITests
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FlickrAppUITests : XCTestCase

@end

@implementation FlickrAppUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFeeds {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app swipeDown];
    
    [[app.collectionViews.cells.otherElements elementBoundByIndex:0] tap];
    
    XCUIElement *currentNavigationBar = [app.navigationBars elementBoundByIndex:0];
    XCTAssertTrue([currentNavigationBar.identifier hasPrefix:@"1 of "]);
}

- (void)testSearch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    [app.navigationBars[@"Popular Feeds"].buttons[@"Search"] tap];
    
    XCUIElement *pullToRefreshTable = [app.tables elementBoundByIndex:0];
    [[pullToRefreshTable childrenMatchingType:XCUIElementTypeSearchField].element tap];
    [[pullToRefreshTable childrenMatchingType:XCUIElementTypeSearchField].element typeText:@"Kittens\n"];
    
    [app swipeUp];
    
    [[app.collectionViews.cells.otherElements elementBoundByIndex:0] tap];
    
    XCUIElement *currentNavigationBar = [app.navigationBars elementBoundByIndex:0];
    XCTAssertTrue([currentNavigationBar.identifier hasPrefix:@"1 of "]);
}

@end

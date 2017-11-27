//
//  SearchAttemptViewModelTests.m
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModelTestCase.h"
#import "SearchAttemptViewModel.h"
#import "SearchAttempt.h"

@interface SearchAttemptViewModelTests : BaseViewModelTestCase

@end

@implementation SearchAttemptViewModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialization
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 2017;
    components.month = 1;
    components.day = 2;
    components.hour = 6;
    components.minute = 51;
    NSDate *date = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:components];
    
    SearchAttempt *searchAttempt = [[SearchAttempt alloc] init];
    searchAttempt.searchTerm = @"kittens";
    searchAttempt.dateSearched = date;
    
    SearchAttemptViewModel *searchAttemptViewModel = [[SearchAttemptViewModel alloc] initWithSearchAttempt: searchAttempt];
    XCTAssertNotNil(searchAttemptViewModel, @"The view model should not be nil.");
    XCTAssertTrue([searchAttemptViewModel.queryString isEqualToString:@"kittens"], @"The item should be equal to the value that was passed in.");
    XCTAssertTrue([searchAttemptViewModel.dateString isEqualToString:@"02/01/2017 06:51"], @"The item should be equal to the value that was passed in.");
}

@end

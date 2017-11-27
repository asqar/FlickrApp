//
//  SearchViewModelTests.m
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModelTestCase.h"
#import "SearchViewModel.h"
#import "SearchAttempt.h"
#import <OCMock/OCMock.h>

@interface SearchViewModelTests : BaseViewModelTestCase

@end

@implementation SearchViewModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testContent
{
    [self.realm beginWriteTransaction];
    SearchAttempt *searchAttempt1 = [[SearchAttempt alloc] init];
    searchAttempt1.searchTerm = @"kittens";
    searchAttempt1.dateSearched = [NSDate date];
    [self.realm addObject:searchAttempt1];
    
    SearchAttempt *searchAttempt2 = [[SearchAttempt alloc] init];
    searchAttempt2.searchTerm = @"puppies";
    searchAttempt2.dateSearched = [NSDate date];
    [self.realm addObject:searchAttempt2];
    
    NSError *error = nil;
    [self.realm commitWriteTransaction:&error];
    XCTAssertNil(error, @"error should be nill");
    
    id mockViewModel = [OCMockObject partialMockForObject:[[SearchViewModel alloc] init]];
    [[[mockViewModel stub] andReturn: self.realm] realm];
    
    XCTAssertNotNil(mockViewModel, @"The view model should not be nil.");
    XCTAssertEqual([mockViewModel numberOfSections], 1);
    XCTAssertEqual([mockViewModel numberOfItemsInSection:0], 2);
}

@end

//
//  PopularFeedsViewModelTests.m
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModelTestCase.h"
#import "PopularFeedsViewModel.h"
#import "Feed.h"
#import <OCMock/OCMock.h>
#import "ImageViewModel.h"

@interface PopularFeedsViewModelTests : BaseViewModelTestCase

@end

@implementation PopularFeedsViewModelTests

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
    Feed *feed1 = [[Feed alloc] init];
    feed1.link = @"http://mofo.com";
    feed1.media = @"http://mofo.com/1.jpg";
    feed1.author = @"asqar";
    feed1.title = @"hello world";
    [self.realm addObject:feed1];
    
    Feed *feed2 = [[Feed alloc] init];
    feed2.link = @"http://fubar.com";
    feed2.media = @"http://fubar.com/2.jpg";
    feed2.author = @"britney";
    feed2.title = @"wassup";
    [self.realm addObject:feed2];
    
    NSError *error = nil;
    [self.realm commitWriteTransaction:&error];
    XCTAssertNil(error, @"error should be nill");
    
    id mockViewModel = [OCMockObject partialMockForObject:[[PopularFeedsViewModel alloc] init]];
    [[[mockViewModel stub] andReturn: self.realm] realm];
    
    XCTAssertNotNil(mockViewModel, @"The view model should not be nil.");
    XCTAssertEqual([mockViewModel numberOfSections], 1);
    XCTAssertEqual([mockViewModel numberOfItemsInSection:0], 2);

    ImageViewModel *imageViewModel = [mockViewModel objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue([imageViewModel.url.absoluteString isEqualToString: @"http://mofo.com/1.jpg"], @"The item should be equal to the value that was passed in.");
    XCTAssertTrue([imageViewModel.caption isEqualToString: @"@asqar"], @"The item should be equal to the value that was passed in.");
}

@end

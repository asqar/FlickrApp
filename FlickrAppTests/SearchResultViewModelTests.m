//
//  SearchResultViewModelTests.m
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModelTestCase.h"
#import "SearchResultViewModel.h"
#import "Photo.h"
#import "ImageViewModel.h"
#import <OCMock/OCMock.h>

@interface SearchResultViewModelTests : BaseViewModelTestCase

@end

@implementation SearchResultViewModelTests

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
    Photo *photo1 = [[Photo alloc] init];
    photo1.title = @"kittens";
    photo1.farm = 5;
    photo1.server = @"4321";
    photo1.photoId = @"2222222222";
    photo1.secret = @"11111111";
    [self.realm addObject:photo1];
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.title = @"puppies";
    photo2.farm = 6;
    photo2.server = @"1234";
    photo2.photoId = @"38633333";
    photo2.secret = @"22222222";
    [self.realm addObject:photo2];
    
    NSError *error = nil;
    [self.realm commitWriteTransaction:&error];
    XCTAssertNil(error, @"error should be nill");
    
    id mockViewModel = [OCMockObject partialMockForObject:[[SearchResultViewModel alloc] init]];
    [[[mockViewModel stub] andReturn: self.realm] realm];
    
    XCTAssertNotNil(mockViewModel, @"The view model should not be nil.");
    XCTAssertEqual([mockViewModel numberOfSections], 1);
    XCTAssertEqual([mockViewModel numberOfItemsInSection:0], 2);
    
    ImageViewModel *imageViewModel = [mockViewModel objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue([imageViewModel.caption isEqualToString:@"kittens"], @"The item should be equal to the value that was passed in.");
    XCTAssertTrue([imageViewModel.url.absoluteString isEqualToString:@"http://farm5.static.flickr.com/4321/2222222222_11111111.jpg"], @"The item should be equal to the value that was passed in.");
}

@end

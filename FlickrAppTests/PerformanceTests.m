//
//  PerformanceTests.m
//  FlickrAppTests
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FeedFetcher.h"
#import "PhotoFetcher.h"

@interface PerformanceTests : XCTestCase

@end

@implementation PerformanceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformance_FeedFetcher
{
    [self measureBlock:^{
        [[FeedFetcher sharedFetcher] fetchManyFromPath:@"" synchronoulsy:YES success:^(NSURLSessionTask *operation, id mappingResult) {
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            XCTFail(@"Failed with error: %@", error);
        }];
    }];
}

- (void)testPerformance_PhotoFetcher
{
    [self measureBlock:^{
        [[PhotoFetcher sharedFetcher] fetchManyFromPath:@"text=kittens" synchronoulsy:YES success:^(NSURLSessionTask *operation, id mappingResult) {
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            XCTFail(@"Failed with error: %@", error);
        }];
    }];
}

@end

//
//  ExpectationTests.m
//  FlickrAppTests
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FeedFetcher.h"
#import "PhotoFetcher.h"
#import "Entities.h"

@interface ExpectationTests : XCTestCase

@end

@implementation ExpectationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExpectation_FeedFetcher
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"FeedFetcher"];
    
    [[FeedFetcher sharedFetcher] fetchManyFromPath:@"" synchronoulsy:YES success:^(NSURLSessionTask *operation, id mappingResult) {
        XCTAssertNotNil(operation, @"mappingResult should not be nil");
        XCTAssertNotNil(mappingResult, @"mappingResult should not be nil");
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        
        XCTAssertEqual(operation.response.URL.absoluteString, operation.originalRequest.URL.absoluteString, @"HTTP response URL should be equal to original URL");
        XCTAssertEqual(httpResponse.statusCode, 200, @"HTTP response status code should be 200");
        XCTAssertTrue([httpResponse.MIMEType isEqualToString: @"application/json"], @"HTTP response content type should be application/json");
        
        XCTAssertTrue([mappingResult isKindOfClass:[NSArray class]], @"mappingResult should be array");
        NSArray *results = mappingResult;
        XCTAssertTrue(results.count > 0, @"mappingResult should not be empty");
        
        for (Feed *item in results) {
            XCTAssertTrue([item isKindOfClass:[Feed class]], @"element should be of Feed class");
        }
        
        [expectation fulfill];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"%@", operation.originalRequest.URL.absoluteString);
        XCTFail(@"Failed with error: %@", error);
    }];
    
    [self waitForExpectations:@[expectation] timeout: 5];
}

- (void)testExpectation_PhotoFetcher
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"PhotoFetcher"];
    
    [[PhotoFetcher sharedFetcher] fetchManyFromPath:@"text=kittens" synchronoulsy:YES success:^(NSURLSessionTask *operation, id mappingResult) {
        XCTAssertNotNil(operation, @"mappingResult should not be nil");
        XCTAssertNotNil(mappingResult, @"mappingResult should not be nil");
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        
        XCTAssertEqual(operation.response.URL.absoluteString, operation.originalRequest.URL.absoluteString, @"HTTP response URL should be equal to original URL");
        XCTAssertEqual(httpResponse.statusCode, 200, @"HTTP response status code should be 200");
        XCTAssertTrue([httpResponse.MIMEType isEqualToString: @"application/json"], @"HTTP response content type should be application/json");
        
        XCTAssertTrue([mappingResult isKindOfClass:[NSArray class]], @"mappingResult should be array");
        NSArray *results = mappingResult;
        XCTAssertTrue(results.count > 0, @"mappingResult should not be empty");
        
        for (Photo *item in results) {
            XCTAssertTrue([item isKindOfClass:[Photo class]], @"element should be of Feed class");
        }
        
        [expectation fulfill];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"%@", operation.originalRequest.URL.absoluteString);
        XCTFail(@"Failed with error: %@", error);
    }];
    
    [self waitForExpectations:@[expectation] timeout: 5];
}

@end

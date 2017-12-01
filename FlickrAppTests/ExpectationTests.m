//
//  ExpectationTests.m
//  FlickrAppTests
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import OCMock

class ExpectationTests : BaseViewModelTestCase {

    func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExpectation_FeedFetcher() {
        let expectation:XCTestExpectation! = self.expectationWithDescription("FeedFetcher")

        let feedFetcher:FeedFetcher! = FeedFetcher.initMe()
        let mockFetcher:AnyObject! = OCMockObject.partialMockForObject(feedFetcher)
        mockFetcher.stub().andReturn(self.realm).realm()

        mockFetcher.fetchManyFromPath("", synchronoulsy:true, success:{ (operation:URLSessionTask!,mappingResult:AnyObject!) in 
            XCTAssertNotNil(operation, "mappingResult should not be nil")
            XCTAssertNotNil(mappingResult, "mappingResult should not be nil")

            let httpResponse:NSHTTPURLResponse! = operation.response

            XCTAssertEqual(operation.response.URL.absoluteString, operation.originalRequest.URL.absoluteString, "HTTP response URL should be equal to original URL")
            XCTAssertEqual(httpResponse.statusCode, 200, "HTTP response status code should be 200")
            XCTAssertTrue((httpResponse.MIMEType == "application/json"), "HTTP response content type should be application/json")

            XCTAssertTrue((mappingResult is NSArray), "mappingResult should be array")
            let results:[AnyObject]! = mappingResult
            XCTAssertTrue(results.count > 0, "mappingResult should not be empty")

            for item:Feed! in results {  
                XCTAssertTrue((item is Feed), "element should be of Feed class")
             }

            expectation.fulfill()
        }, failure:{ (operation:URLSessionTask!,error:NSError!) in 
            NSLog("%@", operation.originalRequest.URL.absoluteString)
    //        XCTFail(@"Failed with error: %@", error);
        })

        self.waitForExpectations([expectation], timeout: 5)
    }

    func testExpectation_PhotoFetcher() {
        let expectation:XCTestExpectation! = self.expectationWithDescription("PhotoFetcher")

        let photoFetcher:PhotoFetcher! = PhotoFetcher.initMe()
        let mockFetcher:AnyObject! = OCMockObject.partialMockForObject(photoFetcher)
        mockFetcher.stub().andReturn(self.realm).realm()

        mockFetcher.fetchManyFromPath("text=kittens", synchronoulsy:true, success:{ (operation:URLSessionTask!,mappingResult:AnyObject!) in 
            XCTAssertNotNil(operation, "mappingResult should not be nil")
            XCTAssertNotNil(mappingResult, "mappingResult should not be nil")

            let httpResponse:NSHTTPURLResponse! = operation.response

            XCTAssertEqual(operation.response.URL.absoluteString, operation.originalRequest.URL.absoluteString, "HTTP response URL should be equal to original URL")
            XCTAssertEqual(httpResponse.statusCode, 200, "HTTP response status code should be 200")
            XCTAssertTrue((httpResponse.MIMEType == "application/json"), "HTTP response content type should be application/json")

            XCTAssertTrue((mappingResult is NSArray), "mappingResult should be array")
            let results:[AnyObject]! = mappingResult
            XCTAssertTrue(results.count > 0, "mappingResult should not be empty")

            for item:Photo! in results {  
                XCTAssertTrue((item is Photo), "element should be of Feed class")
             }

            expectation.fulfill()
        }, failure:{ (operation:URLSessionTask!,error:NSError!) in 
            NSLog("%@", operation.originalRequest.URL.absoluteString)
            XCTFail("Failed with error: %@", error)
        })

        self.waitForExpectations([expectation], timeout: 5)
    }
}

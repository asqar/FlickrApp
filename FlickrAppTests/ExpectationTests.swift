//
//  ExpectationTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

@testable import FlickrApp
import XCTest
import Realm

class ExpectationTests : BaseViewModelTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class MockFeedFetcher : FeedFetcher {
        var _realm:RLMRealm!
        
        init(realm: RLMRealm!)
        {
            _realm = realm
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        override func realm() -> RLMRealm! {
            return _realm
        }
    }
    
    class MockPhotoFetcher : PhotoFetcher {
        var _realm:RLMRealm!
        
        init(realm: RLMRealm!)
        {
            _realm = realm
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        override func realm() -> RLMRealm! {
            return _realm
        }
    }

    func testExpectation_FeedFetcher() {
        let expectation:XCTestExpectation! = self.expectation(description: "FeedFetcher")

        let mockFetcher:FeedFetcher! = MockFeedFetcher(realm: self.realm)

        mockFetcher.fetchManyFromPath(restServiceUrl: "", synchronoulsy:true, success:{ (operation,mappingResult) in
            XCTAssertNotNil(operation, "mappingResult should not be nil")
            XCTAssertNotNil(mappingResult, "mappingResult should not be nil")

            let httpResponse:HTTPURLResponse! = operation!.response as! HTTPURLResponse

            XCTAssertEqual(operation!.response!.url!.absoluteString, operation!.originalRequest!.url!.absoluteString, "HTTP response URL should be equal to original URL")
            XCTAssertEqual(httpResponse.statusCode, 200, "HTTP response status code should be 200")
            XCTAssertTrue((httpResponse.mimeType == "application/json"), "HTTP response content type should be application/json")

            XCTAssertTrue((mappingResult is NSArray), "mappingResult should be array")
            let results:[AnyObject]! = mappingResult as! [AnyObject]
            XCTAssertTrue(results.count > 0, "mappingResult should not be empty")

            for item:Feed! in results as! [Feed]!{
                XCTAssertTrue((item != nil), "element should be of Feed class")
             }

            expectation.fulfill()
        }, failure:{ (operation,error) in
            NSLog("%@", operation!.originalRequest!.url!.absoluteString)
            //XCTFail();
        })

        self.wait(for: [expectation], timeout: 5)
    }

    func testExpectation_PhotoFetcher() {
        let expectation:XCTestExpectation! = self.expectation(description: "PhotoFetcher")

        let mockFetcher:PhotoFetcher! = MockPhotoFetcher(realm: self.realm)

        mockFetcher.fetchManyFromPath(restServiceUrl: "text=kittens", synchronoulsy:true, success:{ (operation,mappingResult) in
            XCTAssertNotNil(operation, "mappingResult should not be nil")
            XCTAssertNotNil(mappingResult, "mappingResult should not be nil")

            let httpResponse:HTTPURLResponse! = operation!.response as! HTTPURLResponse

            XCTAssertEqual(operation!.response!.url!.absoluteString, operation!.originalRequest!.url!.absoluteString, "HTTP response URL should be equal to original URL")
            XCTAssertEqual(httpResponse.statusCode, 200, "HTTP response status code should be 200")
            XCTAssertTrue((httpResponse.mimeType == "application/json"), "HTTP response content type should be application/json")

            XCTAssertTrue((mappingResult is NSArray), "mappingResult should be array")
            let results:[AnyObject]! = mappingResult as! [AnyObject]
            XCTAssertTrue(results.count > 0, "mappingResult should not be empty")

            for item:Photo! in results as! [Photo]! {
                XCTAssertTrue((item != nil), "element should be of Feed class")
             }

            expectation.fulfill()
        }, failure:{ (operation,error) in
            NSLog("%@", operation!.originalRequest!.url!.absoluteString)
            XCTFail()
        })

        self.wait(for: [expectation], timeout: 5)
    }
}

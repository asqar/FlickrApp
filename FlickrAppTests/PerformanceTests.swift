//
//  PerformanceTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

@testable import FlickrApp
import Foundation
import XCTest

class PerformanceTests : BaseViewModelTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerformance_FeedFetcher() {
        self.measure({ 
            FeedFetcher.sharedFetcher.fetchManyFromPath(restServiceUrl: "", synchronoulsy:true, success:{ (operation,mappingResult) in
            }, failure:{ (operation,error) in
                XCTFail()
            })
        })
    }

    func testPerformance_PhotoFetcher() {
        self.measure({ 
            PhotoFetcher.sharedFetcher.fetchManyFromPath(restServiceUrl: "text=kittens", synchronoulsy:true, success:{ (operation,mappingResult) in
            }, failure:{ (operation,error) in
                XCTFail()
            })
        })
    }
}

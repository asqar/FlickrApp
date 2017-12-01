//
//  PerformanceTests.m
//  FlickrAppTests
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

//#import "BaseViewModelTestCase.h"
//#import "FeedFetcher.h"
//#import "PhotoFetcher.h"


class PerformanceTests : BaseViewModelTestCase {

    func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPerformance_FeedFetcher() {
        self.measureBlock({ 
            FeedFetcher.sharedFetcher.fetchManyFromPath("", synchronoulsy:true, success:{ (operation:URLSessionTask!,mappingResult:AnyObject!) in 
            }, failure:{ (operation:URLSessionTask!,error:NSError!) in 
                XCTFail("Failed with error: %@", error)
            })
        })
    }

    func testPerformance_PhotoFetcher() {
        self.measureBlock({ 
            PhotoFetcher.sharedFetcher.fetchManyFromPath("text=kittens", synchronoulsy:true, success:{ (operation:URLSessionTask!,mappingResult:AnyObject!) in
            }, failure:{ (operation:URLSessionTask!,error:NSError!) in 
                XCTFail("Failed with error: %@", error)
            })
        })
    }
}

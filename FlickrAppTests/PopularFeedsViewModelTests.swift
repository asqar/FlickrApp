//
//  PopularFeedsViewModelTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

@testable import FlickrApp
import XCTest
import Realm

class PopularFeedsViewModelTests : BaseViewModelTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class MockPopularFeedsViewModel : PopularFeedsViewModel {
        var _realm:RLMRealm!
        
        init(realm: RLMRealm!)
        {
            _realm = realm
            super.init()
        }
        
        override func realm() -> RLMRealm! {
            return _realm
        }
    }

    func testContent() {
        self.realm.beginWriteTransaction()
        let feed1:Feed! = Feed()
        feed1.link = "http://mofo.com"
        feed1.media = "http://mofo.com/1.jpg"
        feed1.author = "asqar"
        feed1.title = "hello world"
        self.realm.add(feed1)

        let feed2:Feed! = Feed()
        feed2.link = "http://fubar.com"
        feed2.media = "http://fubar.com/2.jpg"
        feed2.author = "britney"
        feed2.title = "wassup"
        self.realm.add(feed2)

        do {
            try self.realm.commitWriteTransaction()
        } catch let error {
            XCTAssertNil(error, "error should be nill")
        }

        let mockViewModel:PopularFeedsViewModel! = MockPopularFeedsViewModel(realm: self.realm)

        XCTAssertNotNil(mockViewModel, "The view model should not be nil.")
        XCTAssertEqual(mockViewModel.numberOfSections(), 1)
        XCTAssertEqual(mockViewModel.numberOfItemsInSection(section: 0), 2)

        let imageViewModel:ImageViewModel! = mockViewModel.objectAtIndexPath(indexPath: IndexPath(row:0, section:0))
        XCTAssertTrue((imageViewModel.url(isThumbnail: false).absoluteString == "http://mofo.com/1.jpg"), "The item should be equal to the value that was passed in.")
        XCTAssertTrue((imageViewModel.caption == "@asqar"), "The item should be equal to the value that was passed in.")
    }
}

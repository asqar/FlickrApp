//
//  SearchResultViewModelTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import XCTest
import OCMock

class SearchResultViewModelTests : BaseViewModelTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContent() {
        self.realm.beginWriteTransaction()
        let photo1:Photo! = Photo()
        photo1.title = "kittens"
        photo1.farm = 5
        photo1.server = "4321"
        photo1.photoId = "2222222222"
        photo1.secret = "11111111"
        self.realm.add(photo1)

        let photo2:Photo! = Photo()
        photo2.title = "puppies"
        photo2.farm = 6
        photo2.server = "1234"
        photo2.photoId = "38633333"
        photo2.secret = "22222222"
        self.realm.add(photo2)

        let error:NSError! = nil
        do {
            try self.realm.commitWriteTransaction()
        } catch {
            
        }
        XCTAssertNil(error, "error should be nill")

        let mockViewModel:AnyObject! = OCMockObject.partialMockForObject(SearchResultViewModel())
        mockViewModel.stub().andReturn(self.realm).realm()

        XCTAssertNotNil(mockViewModel, "The view model should not be nil.")
        XCTAssertEqual(mockViewModel.numberOfSections(), 1)
        XCTAssertEqual(mockViewModel.numberOfItems(0), 2)

        let imageViewModel:PhotoImageViewModel! = mockViewModel.objectAtIndex(IndexPath(row:0, section:0))
        XCTAssertTrue((imageViewModel.caption == "kittens"), "The item should be equal to the value that was passed in.")
        XCTAssertTrue((imageViewModel.url(isThumbnail: true).absoluteString == "http://farm5.static.flickr.com/4321/2222222222_11111111.jpg"), "The item should be equal to the value that was passed in.")
    }
}

//
//  SearchViewModelTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import OCMock

class SearchViewModelTests : BaseViewModelTestCase {

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
        let searchAttempt1:SearchAttempt! = SearchAttempt()
        searchAttempt1.searchTerm = "kittens"
        searchAttempt1.dateSearched = NSDate.date()
        self.realm.addObject(searchAttempt1)

        let searchAttempt2:SearchAttempt! = SearchAttempt()
        searchAttempt2.searchTerm = "puppies"
        searchAttempt2.dateSearched = NSDate.date()
        self.realm.addObject(searchAttempt2)

        let error:NSError! = nil
        self.realm.commitWriteTransaction(&error)
        XCTAssertNil(error, "error should be nill")

        let mockViewModel:AnyObject! = OCMockObject.partialMockForObject(SearchViewModel())
        mockViewModel.stub().andReturn(self.realm).realm()

        XCTAssertNotNil(mockViewModel, "The view model should not be nil.")
        XCTAssertEqual(mockViewModel.numberOfSections(), 1)
        XCTAssertEqual(mockViewModel.numberOfItemsInSection(0), 2)
    }
}

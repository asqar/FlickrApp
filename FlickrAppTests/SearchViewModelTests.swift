//
//  SearchViewModelTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

@testable import FlickrApp
import XCTest
import Realm

class SearchViewModelTests : BaseViewModelTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class MockSearchViewModel : SearchViewModel {
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
        let searchAttempt1:SearchAttempt! = SearchAttempt()
        searchAttempt1.searchTerm = "kittens"
        searchAttempt1.dateSearched = Date() as Date!
        self.realm.add(searchAttempt1)

        let searchAttempt2:SearchAttempt! = SearchAttempt()
        searchAttempt2.searchTerm = "puppies"
        searchAttempt2.dateSearched = Date() as Date!
        self.realm.add(searchAttempt2)

        do {
            try self.realm.commitWriteTransaction()
        } catch let error {
            XCTAssertNil(error, "error should be nill")
        }

        let mockViewModel:SearchViewModel! = MockSearchViewModel(realm: self.realm)

        XCTAssertNotNil(mockViewModel, "The view model should not be nil.")
        XCTAssertEqual(mockViewModel.numberOfSections(), 1)
        XCTAssertEqual(mockViewModel.numberOfItemsInSection(section: 0), 2)
    }
}

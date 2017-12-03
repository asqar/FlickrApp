//
//  SearchAttemptViewModelTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

@testable import FlickrApp
import Foundation
import XCTest

class SearchAttemptViewModelTests : BaseViewModelTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        var components:DateComponents! = DateComponents()
        components.year = 2017
        components.month = 1
        components.day = 2
        components.hour = 6
        components.minute = 51
        let date:Date! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)!.date(from: components)

        let searchAttempt:SearchAttempt! = SearchAttempt()
        searchAttempt.searchTerm = "kittens"
        searchAttempt.dateSearched = date

        let searchAttemptViewModel:SearchAttemptViewModel! = SearchAttemptViewModel(searchAttempt:searchAttempt)
        XCTAssertNotNil(searchAttemptViewModel, "The view model should not be nil.")
        XCTAssertTrue(searchAttemptViewModel.queryString == "kittens", "The item should be equal to the value that was passed in.")
        XCTAssertTrue(searchAttemptViewModel.dateString == "02/01/2017 06:51", "The item should be equal to the value that was passed in.")
    }
}

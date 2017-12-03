//
//  ImageViewModelTests.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import XCTest

class ImageViewModelTests : BaseViewModelTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitializationWithPhoto() {
        let photo:Photo! = Photo()
        photo.title = "kittens"
        photo.farm = 5
        photo.server = "4543"
        photo.photoId = "38637475082"
        photo.secret = "768767868"

        let viewModel:ImageViewModel! = PhotoImageViewModel(photo: photo)
        XCTAssertNotNil(viewModel, "The view model should not be nil.")
        XCTAssertTrue(viewModel.caption == "kittens", "The item should be equal to the value that was passed in.")
        XCTAssertTrue(viewModel.url(isThumbnail: false).absoluteString == "http://farm5.static.flickr.com/4543/38637475082_768767868.jpg", "The item should be equal to the value that was passed in.")
    }

    func testInitializationWithFeed() {
        let feed:Feed! = Feed()
        feed.author = "asqar"
        feed.media = "https://farm5.staticflickr.com/4534/37941560534_557576567_m.jpg"

        let viewModel:ImageViewModel! = FeedImageViewModel(feed:feed)
        XCTAssertNotNil(viewModel, "The view model should not be nil.")
        XCTAssertTrue(viewModel.caption == "@asqar", "The item should be equal to the value that was passed in.")
        XCTAssertTrue(viewModel.url(isThumbnail: false).absoluteString == "https://farm5.staticflickr.com/4534/37941560534_557576567.jpg", "The item should be equal to the value that was passed in.")
    }
}

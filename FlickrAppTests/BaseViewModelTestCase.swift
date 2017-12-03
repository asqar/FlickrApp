//
//  BaseViewModelTestCase.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

@testable import FlickrApp
import Realm
import XCTest
import Foundation

class BaseViewModelTestCase : XCTestCase {

    private(set) var realm:RLMRealm!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let config:RLMRealmConfiguration! = RLMRealmConfiguration.default()
        config.inMemoryIdentifier = self.name
        RLMRealmConfiguration.setDefault(config)

        do {
            self.realm = try RLMRealm(configuration: config)
        } catch let error {
            print(error)
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

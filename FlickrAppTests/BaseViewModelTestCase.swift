//
//  BaseViewModelTestCase.swift
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

import Realm
import XCTest

class BaseViewModelTestCase : XCTestCase {

    private(set) var realm:RLMRealm!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let config:RLMRealmConfiguration! = RLMRealmConfiguration.defaultConfiguration()
        config.schemaVersion = 1
        config.deleteRealmIfMigrationNeeded = true
        config.inMemoryIdentifier = self.self.description()
        RLMRealmConfiguration.defaultConfiguration = config

        let error:NSError! = nil
        self.realm = RLMRealm.realmWithConfiguration(config, error: &error)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

//
//  BaseViewModelTestCase.h
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BaseViewModelTestCase : XCTestCase

@property (nonatomic, readonly) RLMRealm *realm;

@end

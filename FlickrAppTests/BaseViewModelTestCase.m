//
//  BaseViewModelTestCase.m
//  FlickrAppTests
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModelTestCase.h"
#import <Realm/Realm.h>

@interface BaseViewModelTestCase()

@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation BaseViewModelTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    config.deleteRealmIfMigrationNeeded = YES;
    config.inMemoryIdentifier = [self.class description];
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    NSError *error = nil;
    self.realm = [RLMRealm realmWithConfiguration:config error: &error];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end

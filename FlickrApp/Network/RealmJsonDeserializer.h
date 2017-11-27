//
//  RLMObject+JsonDeserializer.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Realm/Realm.h>

@protocol RealmJsonDeserializer

+ (instancetype) deserializeOne: (NSDictionary *) d inRealm: (RLMRealm *) realm;
+ (NSArray *) deserializeMany: (NSArray *) a inRealm: (RLMRealm *) realm;

@end

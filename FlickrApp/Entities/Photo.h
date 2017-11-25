//
//  Photo.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Realm/Realm.h>

@class SearchAttempt;

@interface Photo : RLMObject

@property NSString *photoId;
@property NSString *owner;
@property NSString *secret;
@property NSString *server;
@property int farm;
@property NSString *title;
@property int isPublic;
@property int isFriend;
@property int isFamily;
@property NSNumber<RLMInt> *orderIndex;

@property SearchAttempt *searchAttempt;

@end

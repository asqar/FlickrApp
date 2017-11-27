//
//  Feed.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Realm/Realm.h>

@interface Feed : RLMObject

@property NSString *title;
@property NSString *link;
@property NSString *media;
@property NSDate *dateTaken;
@property NSString *descr;
@property NSDate *datePublished;
@property NSString *author;
@property NSString *authorId;
@property NSString *tags;

@end

//
//  SearchAttempt.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Realm/Realm.h>

@interface SearchAttempt : RLMObject

@property NSString *searchTerm;
@property NSDate *dateSearched;
@property BOOL isSuccessful;

@property (readonly) RLMLinkingObjects *photos;

@end

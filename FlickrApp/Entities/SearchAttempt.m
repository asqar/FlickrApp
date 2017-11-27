//
//  SearchAttempt.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchAttempt.h"
#import "Photo.h"

@implementation SearchAttempt

+ (NSString *)primaryKey {
    return @"searchTerm";
}

+ (NSDictionary *)linkingObjectsProperties {
    return @{
             @"photos": [RLMPropertyDescriptor descriptorWithClass:Photo.class propertyName:@"searchAttempt"],
             };
}

@end

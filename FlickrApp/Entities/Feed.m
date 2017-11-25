//
//  Feed.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "Feed.h"
#import <Realm+JSON/RLMObject+JSON.h>

@implementation Feed

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"title" : @"title",
             @"link" : @"link",
             @"media.m" : @"media",
             @"date_taken" : @"dateTaken",
             @"description" : @"descr",
             @"published" : @"datePublished",
             @"author" : @"author",
             @"author_id" : @"authorId",
             @"tags" : @"tags",
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             };
}

+ (NSString *)primaryKey {
    return @"link";
}

+ (NSArray *) ignoredProperties
{
    return @[
             ];
}

+ (instancetype) deserializeOne: (NSDictionary *) d
{
    Feed *item = [Feed createOrUpdateInRealm:[RLMRealm defaultRealm] withJSONDictionary: d];
    return item;
}

+ (NSArray *) deserializeMany: (NSArray *) a
{
    if ([a isKindOfClass:[NSDictionary class]]) {
        a = [((NSDictionary *) a) objectForKey:@"items"];
    }
    if ([a isKindOfClass:[NSDictionary class]]) {
        a = [((NSDictionary *) a) objectForKey:@"photo"];
    }
    NSArray *result = [Feed createOrUpdateInRealm:[RLMRealm defaultRealm] withJSONArray: a];
    for (Feed *item in result){

    }
    return result;
}

@end

//
//  Photo.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "Photo.h"
#import <Realm+JSON/RLMObject+JSON.h>

@implementation Photo

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"id" : @"photoId",
             @"owner" : @"owner",
             @"secret" : @"secret",
             @"server" : @"server",
             @"farm" : @"farm",
             @"title" : @"title",
             @"ispublic" : @"isPublic",
             @"isfriend" : @"isFriend",
             @"isfamily" : @"isFamily",
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             };
}

+ (NSString *)primaryKey {
    return @"photoId";
}

+ (NSArray *) ignoredProperties
{
    return @[
             ];
}

+ (instancetype) deserializeOne: (NSDictionary *) d inRealm: (RLMRealm *) realm
{
    Photo *item = [Photo createOrUpdateInRealm:realm withJSONDictionary: d];
    return item;
}

+ (NSArray *) deserializeMany: (NSArray *) a inRealm: (RLMRealm *) realm
{
    if ([a isKindOfClass:[NSDictionary class]]) {
        a = [((NSDictionary *) a) objectForKey:@"photos"];
    }
    if ([a isKindOfClass:[NSDictionary class]]) {
        a = [((NSDictionary *) a) objectForKey:@"photo"];
    }
    return [Photo createOrUpdateInRealm:realm withJSONArray: a];
}

@end

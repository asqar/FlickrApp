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

+ (instancetype) deserializeOne: (NSDictionary *) d
{
    Photo *item = [Photo createOrUpdateInRealm:[RLMRealm defaultRealm] withJSONDictionary: d];
    // establish relations if needed
    // item.blablabla = [BLablabla objectWithId: @(blablablaId)];
    return item;
}

+ (NSArray *) deserializeMany: (NSArray *) a
{
    if ([a isKindOfClass:[NSDictionary class]]) {
        a = [((NSDictionary *) a) objectForKey:@"photos"];
    }
    if ([a isKindOfClass:[NSDictionary class]]) {
        a = [((NSDictionary *) a) objectForKey:@"photo"];
    }
    NSArray *result = [Photo createOrUpdateInRealm:[RLMRealm defaultRealm] withJSONArray: a];
//    for (Photo *item in result){
        // establish relations if needed
        // item.blablabla = [BLablabla objectWithId: @(blablablaId)];
//    }
    return result;
}

@end

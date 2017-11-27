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
    
    NSString *pattern = @"(?<=\").+(?=\")";
    NSError  *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    
    for (Feed *item in result){
        NSString *searchedString = item.author;
        NSArray* matches = [regex matchesInString:searchedString options:0 range: NSMakeRange(0, [searchedString length])];
        NSTextCheckingResult *match = matches.firstObject;
        if (match) {
            NSString* matchText = [searchedString substringWithRange:[match range]];
            item.author = matchText;
        }
    }
    return result;
}

@end

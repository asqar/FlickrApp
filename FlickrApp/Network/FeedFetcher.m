//
//  FeedFetcher.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "FeedFetcher.h"
#import "Entities.h"

@implementation FeedFetcher

+ (FeedFetcher *)sharedFetcher{
    static FeedFetcher *_sharedFetcher = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedFetcher = [[self alloc] initMe];
    });
    
    return _sharedFetcher;
}

- (id) initMe
{
    self = [super initWithEntity:[Feed class] serviceName:[NSString stringWithFormat:@"services/feeds/photos_public.gne?format=json&format=json&nojsoncallback=1&"] singleName:@"feed" pluralName:@"feeds"];
    return self;
}

@end

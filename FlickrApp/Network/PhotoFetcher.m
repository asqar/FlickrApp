//
//  PhotoFetcher.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "PhotoFetcher.h"
#import "Photo.h"

@implementation PhotoFetcher

+ (PhotoFetcher *)sharedFetcher{
    static PhotoFetcher *_sharedFetcher = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedFetcher = [[self alloc] initMe];
    });
    
    return _sharedFetcher;
}

- (id) initMe
{
    self = [super initWithEntity:[Photo class] serviceName:[NSString stringWithFormat:@"services/rest/?method=flickr.photos.search&api_key=%@&format=json&nojsoncallback=1&", FLICKR_SEARCH_API_KEY] singleName:@"photo" pluralName:@"photos"];
    return self;
}

@end

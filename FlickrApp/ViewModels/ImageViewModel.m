//
//  ImageViewModel.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ImageViewModel.h"
#import "Photo.h"
#import "Feed.h"

@implementation ImageViewModel

-(instancetype)initWithPhoto:(Photo *)photo
{
    self = [super init];
    if (self == nil)
        return nil;
    NSString *urlString = [NSString stringWithFormat:PHOTO_URL_FORMAT, photo.farm, photo.server, photo.photoId, photo.secret];
    self.url = [NSURL URLWithString: urlString];
    self.caption = photo.title;
    return self;
}

-(instancetype)initWithFeed:(Feed *)feed
{
    self = [super init];
    if (self == nil)
        return nil;
    self.url = [NSURL URLWithString: feed.media];
    self.caption = feed.title;
    return self;
}

@end

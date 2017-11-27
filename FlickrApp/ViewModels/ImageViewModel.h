//
//  ImageViewModel.h
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo, Feed;

@interface ImageViewModel : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *caption;

-(instancetype)initWithPhoto: (Photo *) photo;
-(instancetype)initWithFeed: (Feed *) feed;

@end

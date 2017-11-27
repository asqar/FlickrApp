//
//  ImageViewModel.h
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModel.h"

@class Photo, Feed;

@interface ImageViewModel : BaseViewModel

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *caption;

-(instancetype)initWithPhoto: (Photo *) photo;
-(instancetype)initWithFeed: (Feed *) feed;

@end

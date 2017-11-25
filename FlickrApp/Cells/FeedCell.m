//
//  FeedCell.m
//  FlickrApp
//
//  Created by aSqar on 24.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "FeedCell.h"
#import "Entities.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FeedCell()

@property (nonatomic, weak) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@end

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setFeed:(Feed *)feed
{
    _feed = feed;
    
    [_imgPhoto sd_setImageWithURL: [NSURL URLWithString:feed.media] placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                          options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
                              [self.progressView setProgress: receivedSize / expectedSize];
                          } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                              NSLog(@"%@ %@", imageURL, error);
                              self.progressView.hidden = YES;
                          }];
    
    _lblName.text = feed.title;
}


@end

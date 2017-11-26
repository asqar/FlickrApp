//
//  PhotoCell.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "PhotoCell.h"
#import "Entities.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@end

@implementation PhotoCell

- (void) setPhoto:(Photo *)photo
{
    _photo = photo;
    
    NSString *urlStr = [NSString stringWithFormat:THUMBNAIL_PHOTO_URL_FORMAT, photo.farm, photo.server, photo.photoId, photo.secret];
    
    [_imgPhoto sd_setImageWithURL: [NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"]
     options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
         [self.progressView setProgress: receivedSize / expectedSize];
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
         self.progressView.hidden = YES;
    }];
    
    _lblName.text = photo.title;
}

@end

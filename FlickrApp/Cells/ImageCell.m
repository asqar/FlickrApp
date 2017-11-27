//
//  ImageCell.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ImageCell.h"
#import "ImageViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImageCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@end

@implementation ImageCell

- (void) setViewModel:(ImageViewModel *)viewModel
{
    _viewModel = viewModel;
    
    [_imgPhoto sd_setImageWithURL: viewModel.url placeholderImage:[UIImage imageNamed:@"placeholder.png"]
     options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
         [self.progressView setProgress: receivedSize / expectedSize];
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
         self.progressView.hidden = YES;
    }];
    
    _lblName.text = viewModel.caption;
}

@end

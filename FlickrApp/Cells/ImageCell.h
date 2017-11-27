//
//  ImageCell.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageViewModel;

@interface ImageCell : UICollectionViewCell

@property (nonatomic, strong) ImageViewModel *viewModel;

@end

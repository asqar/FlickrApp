//
//  PopularFeedsViewController.h
//  FlickrApp
//
//  Created by aSqar on 24.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ImageListViewController.h"

@class PopularFeedsViewModel;

@interface PopularFeedsViewController : ImageListViewController

@property (nonatomic, strong) PopularFeedsViewModel *viewModel;

@end

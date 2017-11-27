//
//  SearchResultViewController.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ImageListViewController.h"

@class SearchResultViewModel;

@interface SearchResultViewController : ImageListViewController

@property (nonatomic, strong) SearchResultViewModel *viewModel;

@end

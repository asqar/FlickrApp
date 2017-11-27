//
//  SearchViewController.h
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchViewModel;

@interface SearchViewController : UITableViewController

@property (nonatomic, strong) SearchViewModel *viewModel;

@end

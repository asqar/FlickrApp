//
//  SearchResultViewController.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultViewModel.h"
#import "UIViewController+LoadingView.h"

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) showSpinner
{
    [self showLoadingView:MyLocalizedString(@"Loading search results...", nil)];
}

- (void) setViewModel:(SearchResultViewModel *)viewModel
{
    _viewModel = viewModel;
}

@end

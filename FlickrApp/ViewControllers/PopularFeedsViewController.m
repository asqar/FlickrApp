//
//  PopularFeedsViewController.m
//  FlickrApp
//
//  Created by aSqar on 24.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "PopularFeedsViewController.h"
#import "PopularFeedsViewModel.h"
#import "UIViewController+LoadingView.h"
#import "SearchViewController.h"
#import "SearchViewModel.h"

@implementation PopularFeedsViewController

- (void)viewDidLoad
{
    self.viewModel = [[PopularFeedsViewModel alloc] init];
    [super viewDidLoad];
}

- (void) showSpinner
{
    [self showLoadingView:MyLocalizedString(@"Loading feeds...", nil)];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SearchViewController class]]) {
        SearchViewModel *searchViewModel = [[SearchViewModel alloc] init];
        SearchViewController *vc = (SearchViewController *) segue.destinationViewController;
        vc.viewModel = searchViewModel;
    }
}

@end

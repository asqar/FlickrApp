//
//  UIViewController+LoadingView.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "UIViewController+LoadingView.h"
#import "DejalActivityView.h"

@implementation UIViewController(LoadingView)

- (void) showLoadingView: (NSString *) msg
{
    if ([DejalBezelActivityView currentActivityView] != nil)
    {
        [DejalBezelActivityView currentActivityView].activityLabel.text = msg;
    } else {
        [DejalBezelActivityView activityViewForView: self.view withLabel: msg width:250.0f];
    }
}

- (void) hideLoadingView
{
    [DejalBezelActivityView removeViewAnimated: YES];
}

@end

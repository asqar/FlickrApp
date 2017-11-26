//
//  UIViewController+LoadingView.h
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface UIViewController (LoadingView)

- (void) showLoadingView: (NSString *) msg;
- (void) hideLoadingView;

@end

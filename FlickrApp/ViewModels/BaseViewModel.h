//
//  BaseViewModel.h
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface BaseViewModel : RVMViewModel

- (RLMRealm *) realm;

@end

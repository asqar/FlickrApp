//
//  BaseViewModel.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (RLMRealm *) realm
{
    return [RLMRealm defaultRealm];
}

@end

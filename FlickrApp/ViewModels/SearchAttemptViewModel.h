//
//  SearchAttemptViewModel.h
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchAttempt;

@interface SearchAttemptViewModel : NSObject

@property (nonatomic, strong) NSString *queryString;
@property (nonatomic, strong) NSString *dateString;

@property (nonatomic, readonly) SearchAttempt *searchAttempt;

-(instancetype)initWithSearchAttempt: (SearchAttempt *) searchAttempt;

@end

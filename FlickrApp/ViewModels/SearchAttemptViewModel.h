//
//  SearchAttemptViewModel.h
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModel.h"

@class SearchAttempt;

@interface SearchAttemptViewModel : BaseViewModel

@property (nonatomic, strong) NSString *queryString;
@property (nonatomic, strong) NSString *dateString;

-(instancetype)initWithSearchAttempt: (SearchAttempt *) searchAttempt;

@end

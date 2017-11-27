//
//  SearchResultViewModel.h
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ImageListViewModel.h"

@class SearchAttempt, SearchAttemptViewModel;

@interface SearchResultViewModel : ImageListViewModel

-(instancetype)initWithSearchAttemptViewModel: (SearchAttemptViewModel *) searchAttemptViewModel;
-(instancetype)initWithSearchQuery: (NSString *) searchQuery;

@end

//
//  SearchViewModel.h
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "BaseViewModel.h"

@class SearchAttemptViewModel;

@interface SearchViewModel : BaseViewModel

@property (nonatomic, readonly) RACSignal *updatedContentSignal;

- (void) loadHistory;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
- (SearchAttemptViewModel *) objectAtIndexPath: (NSIndexPath *) indexPath;

@end

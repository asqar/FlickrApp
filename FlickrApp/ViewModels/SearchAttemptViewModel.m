//
//  SearchAttemptViewModel.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchAttemptViewModel.h"
#import "SearchAttempt.h"

@interface SearchAttemptViewModel()

@end

@implementation SearchAttemptViewModel

-(instancetype)initWithSearchAttempt:(SearchAttempt *)searchAttempt
{
    self = [super init];
    if (self == nil)
        return nil;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/YYYY HH:mm";
    self.dateString = [dateFormatter stringFromDate:searchAttempt.dateSearched];
    self.queryString = searchAttempt.searchTerm;
    
    return self;
}

@end

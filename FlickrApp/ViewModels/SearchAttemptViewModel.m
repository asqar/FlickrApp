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
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    self.dateString = [dateFormatter stringFromDate:searchAttempt.dateSearched];
    self.queryString = searchAttempt.searchTerm;
    
    return self;
}

-(instancetype)initWithQuery:(NSString *)queryString
{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    
    SearchAttempt *searchAttempt = [[SearchAttempt alloc] init];
    searchAttempt.searchTerm = queryString;
    searchAttempt.dateSearched = [NSDate date];
    [[RLMRealm defaultRealm] addOrUpdateObject: searchAttempt];
    
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
    return [self initWithSearchAttempt: searchAttempt];
}

@end

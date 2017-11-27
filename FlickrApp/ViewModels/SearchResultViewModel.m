//
//  SearchResultViewModel.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchResultViewModel.h"
#import "SearchAttemptViewModel.h"
#import "SearchAttempt.h"
#import "PhotoFetcher.h"
#import "Photo.h"
#import "ImageViewModel.h"

@interface SearchResultViewModel()

@property (nonatomic, strong) SearchAttempt *searchAttempt;

@end

@implementation SearchResultViewModel

-(instancetype)initWithSearchAttemptViewModel: (SearchAttemptViewModel *) searchAttemptViewModel
{
    return [self initWithSearchQuery: searchAttemptViewModel.queryString];
}

-(instancetype)initWithSearchQuery: (NSString *) searchQuery
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self.realm beginWriteTransaction];
    SearchAttempt *searchAttempt = [[SearchAttempt alloc] init];
    searchAttempt.searchTerm = searchQuery;
    searchAttempt.dateSearched = [NSDate date];
    [self.realm addOrUpdateObject: searchAttempt];
    [self.realm commitWriteTransaction];
    
    self.searchAttempt = searchAttempt;
    return self;
}

- (NSString *) title
{
    return _searchAttempt.searchTerm;
}

- (RemoteFetcher *) fetcher
{
    return [PhotoFetcher sharedFetcher];
}

- (RBQFetchRequest *) fetchRequest
{
    RLMSortDescriptor *sd1 = [RLMSortDescriptor sortDescriptorWithKeyPath:@"orderIndex" ascending:YES];
    NSArray *sortDescriptors = @[ sd1 ];
    
    RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:@"Photo" inRealm:self.realm predicate:nil];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"searchAttempt.searchTerm == %@", self.searchAttempt.searchTerm];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

- (NSString *) serviceUrl
{
    NSString *encodedStr = [self.searchAttempt.searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return [NSString stringWithFormat:@"text=%@", encodedStr];
}

- (void) processDownloadedResults: (NSArray *) results
{
    [self.realm transactionWithBlock: ^ {
        
        NSInteger orderIndex = [self numberOfItemsInSection:0] + 1;
        for (Photo *item in results) {
            item.orderIndex = @(orderIndex);
            item.searchAttempt = self.searchAttempt;
            orderIndex++;
        }
    }];
}

- (ImageViewModel *) objectAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.fetchedResultsController objectAtIndexPath: indexPath];
    return [[ImageViewModel alloc] initWithPhoto:photo];
}

@end

//
//  PopularFeedsViewModel.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "PopularFeedsViewModel.h"
#import "Feed.h"
#import "FeedFetcher.h"
#import "ImageViewModel.h"

@implementation PopularFeedsViewModel

- (NSString *) title
{
    return MyLocalizedString(@"Popular Feeds", nil);
}

- (RemoteFetcher *) fetcher
{
    return [FeedFetcher sharedFetcher];
}

- (RBQFetchRequest *) fetchRequest
{
    RLMSortDescriptor *sd1 = [RLMSortDescriptor sortDescriptorWithKeyPath:@"datePublished" ascending:YES];
    NSArray *sortDescriptors = @[ sd1 ];
    RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:@"Feed" inRealm:[RLMRealm defaultRealm] predicate:nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

- (NSString *) serviceUrl
{
    return @"";
}

- (void) processDownloadedResults: (NSArray *) results
{
}

- (ImageViewModel *) objectAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [self.fetchedResultsController objectAtIndexPath: indexPath];
    return [[ImageViewModel alloc] initWithFeed:feed];
}

@end

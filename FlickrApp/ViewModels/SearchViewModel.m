//
//  SearchViewModel.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchAttemptViewModel.h"

@interface SearchViewModel()<RBQFetchedResultsControllerDelegate>

@property (nonatomic, strong) RACSubject *updatedContentSignal;
@property (nonatomic, strong) RBQFetchedResultsController *fetchedResultsController;

@end

@implementation SearchViewModel

#pragma mark - Public methods

-(instancetype)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"SearchResultViewModel updatedContentSignal"];
    
    @weakify(self)
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [self loadHistory];
    }];
    
    return self;
}

- (void) loadHistory
{
    [self.fetchedResultsController performFetch];
}

-(NSInteger)numberOfSections
{
    return [self.fetchedResultsController numberOfSections];
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedResultsController numberOfRowsForSectionIndex:section];
}

-(SearchAttemptViewModel *) objectAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAttempt *search = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [[SearchAttemptViewModel alloc] initWithSearchAttempt:search];
}

#pragma mark - Fetched results controller

- (RBQFetchRequest *) fetchRequest
{
    RLMSortDescriptor *sd1 = [RLMSortDescriptor sortDescriptorWithKeyPath:@"dateSearched" ascending:NO];
    NSArray *sortDescriptors = @[ sd1 ];
    
    RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:@"SearchAttempt" inRealm:self.realm predicate:nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

- (RBQFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        _fetchedResultsController = [[RBQFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        [_fetchedResultsController performFetch];
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(RBQFetchedResultsController *)controller
{
    [(RACSubject *)self.updatedContentSignal sendNext:nil];
}

- (void)controllerWillChangeContent:(nonnull RBQFetchedResultsController *)controller
{
    
}

- (void)controller:(nonnull RBQFetchedResultsController *)controller
   didChangeObject:(nonnull RBQSafeRealmObject *)anObject
       atIndexPath:(nullable NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(nullable NSIndexPath *)newIndexPath
{
    
}

- (void)controller:(nonnull RBQFetchedResultsController *)controller
  didChangeSection:(nonnull RBQFetchedResultsSectionInfo *)section
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    
}

@end

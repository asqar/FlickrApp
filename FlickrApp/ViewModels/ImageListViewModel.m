//
//  ImageListViewModel.m
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ImageListViewModel.h"
#import "ImageViewModel.h"
#import "RemoteFetcher.h"

@interface ImageListViewModel()<RBQFetchedResultsControllerDelegate>

@property (nonatomic, strong) RACSubject *updatedContentSignal;
@property (nonatomic, strong) RACSubject *startLoadingSignal;
@property (nonatomic, strong) RACSubject *dismissLoadingSignal;
@property (nonatomic, strong) RACSubject *errorMessageSignal;

@property (nonatomic, strong) RBQFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) int currentPage;

@end

@implementation ImageListViewModel

#pragma mark - Public methods

-(instancetype)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"ImageListViewModel updatedContentSignal"];
    self.startLoadingSignal = [[RACSubject subject] setNameWithFormat:@"ImageListViewModel startLoadingSignal"];
    self.dismissLoadingSignal = [[RACSubject subject] setNameWithFormat:@"ImageListViewModel dismissLoadingSignal"];
    self.errorMessageSignal = [[RACSubject subject] setNameWithFormat:@"ImageListViewModel errorMessageSignal"];
    
    self.currentPage = 1;
    
    @weakify(self)
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
    }];
    
    return self;
}

-(NSInteger)numberOfSections
{
    return [self.fetchedResultsController numberOfSections];
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedResultsController numberOfRowsForSectionIndex:section];
}

// to be overriden
- (ImageViewModel *) objectAtIndexPath: (NSIndexPath *) indexPath
{
    return nil;
}

#pragma mark - Search

- (void) processDownloadedResults: (NSArray *) results {}

- (void) downloadImagesUpdating: (BOOL)updating
{
    if (updating) {
        self.currentPage = 1;
    } else {
        self.currentPage++;
    }
    
    [self.fetcher fetchManyFromPath:[NSString stringWithFormat:@"%@&per_page=%d&page=%d", self.serviceUrl, PER_PAGE, self.currentPage]  synchronoulsy:NO success:^(NSURLSessionTask *operation, id mappingResult) {
        
        [self processDownloadedResults: mappingResult];

        _fetchedResultsController = nil;
        
        [(RACSubject *)self.updatedContentSignal sendNext:nil];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [self.dismissLoadingSignal doNext: nil];
        
#ifdef DEBUG
        NSLog(@"%@", error);
        //[self.errorMessageSignal doNext: error];
#endif
    }];
}

#pragma mark - Fetched results controller

- (RBQFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        _fetchedResultsController = [[RBQFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        [_fetchedResultsController performFetch];
        [(RACSubject *)self.dismissLoadingSignal sendNext:nil];
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

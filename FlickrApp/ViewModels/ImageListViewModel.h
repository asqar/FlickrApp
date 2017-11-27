//
//  ImageListViewModel.h
//  FlickrApp
//
//  Created by aSqar on 26.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class SearchAttempt, Photo, ImageViewModel, RemoteFetcher;

@interface ImageListViewModel : RVMViewModel

@property (nonatomic, readonly) RACSignal *updatedContentSignal;
@property (nonatomic, readonly) RACSignal *startLoadingSignal;
@property (nonatomic, readonly) RACSignal *dismissLoadingSignal;
@property (nonatomic, readonly) RACSignal *errorMessageSignal;
@property (nonatomic, readonly) NSString *title;

// to be overriden
@property (nonatomic, readonly) RemoteFetcher *fetcher;
@property (nonatomic, readonly) RBQFetchRequest *fetchRequest;
@property (nonatomic, readonly) RBQFetchedResultsController *fetchedResultsController;
@property (nonatomic, readonly) NSString *serviceUrl;
- (void) processDownloadedResults: (NSArray *) results;

-(instancetype)init;

- (void) downloadImagesUpdating: (BOOL)updating;
-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
- (ImageViewModel *) objectAtIndexPath: (NSIndexPath *) indexPath;

@end

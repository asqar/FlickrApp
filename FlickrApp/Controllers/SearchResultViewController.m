//
//  SearchResultViewController.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchResultViewController.h"
#import "PhotoFetcher.h"
#import "Entities.h"
#import "PhotoCell.h"
#import "UIViewController+LoadingView.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <FMMosaicLayout/FMMosaicLayout.h>

static const CGFloat kFMHeaderFooterHeight  = 44.0;
static const NSInteger kFMMosaicColumnCount = 2;

@interface SearchResultViewController ()<RBQFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) RBQFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) SVPullToRefreshView *pullToRefreshView;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@end

@implementation SearchResultViewController

- (void)dealloc
{
    _photoBrowser.delegate = nil;
    _photoBrowser = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.searchAttempt.searchTerm;
    self.currentPage = 1;
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf loadPhotosUpdating:YES];
    }];
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadPhotosUpdating:NO];
    }];
    
    [self showLoadingView:MyLocalizedString(@"Loading...", nil)];
    [self loadPhotosUpdating:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    _photoBrowser.delegate = nil;
    _photoBrowser = nil;
    [super viewDidDisappear: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search

- (void) loadPhotosUpdating: (BOOL)updating
{
    if (updating) {
        self.currentPage = 1;
    } else {
        self.currentPage++;
    }
    
    NSString *encodedStr = [self.searchAttempt.searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    [[PhotoFetcher sharedFetcher] fetchManyFromPath:[NSString stringWithFormat:@"text=%@&per_page=%d&page=%d", encodedStr, PER_PAGE, self.currentPage]  synchronoulsy:NO success:^(NSURLSessionTask *operation, id mappingResult) {
        
        [[RLMRealm defaultRealm] transactionWithBlock: ^ {
            
            NSInteger orderIndex = self.fetchedResultsController.fetchedObjects.count + 1;
            for (Photo *item in mappingResult) {
                item.orderIndex = @(orderIndex);
                NSLog(@"%@", item);
                item.searchAttempt = self.searchAttempt;
                orderIndex++;
            }
        }];
        
        NSLog(@"%@ %@", operation, mappingResult);
        
        [self hideLoadingView];
        [KVNProgress dismiss];
        
        _fetchedResultsController = nil;
        [self.fetchedResultsController performFetch];
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView.infiniteScrollingView stopAnimating];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [KVNProgress dismiss];
        [self hideLoadingView];
#ifdef DEBUG
        NSLog(@"%@", error);
#endif
        //[KVNProgress showErrorWithStatus:MyLocalizedString(@"Technical error. Try again later", nil)];
    }];
}

#pragma mark - Fetched results controller

- (RBQFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        RLMSortDescriptor *sd1 = [RLMSortDescriptor sortDescriptorWithKeyPath:@"orderIndex" ascending:YES];
        NSArray *sortDescriptors = @[ sd1 ];
        
        RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:@"Photo" inRealm:[RLMRealm defaultRealm] predicate:nil];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"searchAttempt.searchTerm == %@", self.searchAttempt.searchTerm];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        
        _fetchedResultsController = [[RBQFetchedResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        [_fetchedResultsController performFetch];
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(RBQFetchedResultsController *)controller
{
    [self.collectionView reloadData];
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

#pragma mark - FMMosaicLayoutDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
   numberOfColumnsInSection:(NSInteger)section {
    return kFMMosaicColumnCount;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
  mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.item % 12 == 0) ? FMMosaicCellSizeBig : FMMosaicCellSizeSmall;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
interitemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
 heightForHeaderInSection:(NSInteger)section {
    return kFMHeaderFooterHeight;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
 heightForFooterInSection:(NSInteger)section {
    return kFMHeaderFooterHeight;
}

- (BOOL)headerShouldOverlayContentInCollectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout {
    return YES;
}

- (BOOL)footerShouldOverlayContentInCollectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout {
    return YES;
}

#pragma mark - UICollectionView data source

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.fetchedResultsController numberOfSections];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedResultsController numberOfRowsForSectionIndex: section];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath: indexPath];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath: indexPath];
    cell.photo = photo;
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.photoBrowser setCurrentPhotoIndex: indexPath.row];
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - MWPhotoProwser delegate

- (MWPhotoBrowser *) photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.view.backgroundColor = [UIColor blackColor];
        _photoBrowser.displayActionButton = NO;
        _photoBrowser.alwaysShowControls = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
        int majorNumber = [[iosVersion substringToIndex: 1] intValue];
        if (majorNumber >= 7) {
            _photoBrowser.edgesForExtendedLayout = UIRectEdgeNone;
            _photoBrowser.extendedLayoutIncludesOpaqueBars = NO;
        }
    }
    return _photoBrowser;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.fetchedResultsController.fetchedObjects.count) {
        Photo *photo = [self.fetchedResultsController.fetchedObjects objectAtIndex: index];
        NSString *urlStr = [NSString stringWithFormat:PHOTO_URL_FORMAT, photo.farm, photo.server, photo.photoId, photo.secret];
        MWPhoto *photoObj = [MWPhoto photoWithURL:[NSURL URLWithString: urlStr]];
        return photoObj;
    }
    return nil;
}

@end

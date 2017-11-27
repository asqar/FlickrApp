//
//  ImageListViewController.m
//  FlickrApp
//
//  Created by aSqar on 27.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "ImageListViewController.h"
#import "ImageCell.h"
#import "ImageViewModel.h"
#import "ImageListViewModel.h"
#import "UIViewController+LoadingView.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <FMMosaicLayout/FMMosaicLayout.h>

static const CGFloat kFMHeaderFooterHeight  = 44.0;
static const NSInteger kFMMosaicColumnCount = 2;

@interface ImageListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>

@property (nonatomic, readonly) ImageListViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) SVPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@end

@implementation ImageListViewController

- (void)dealloc
{
    _photoBrowser.delegate = nil;
    _photoBrowser = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.viewModel.title;
    
    @weakify(self);
    [self.collectionView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self.viewModel downloadImagesUpdating:YES];
    }];
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [self.viewModel downloadImagesUpdating:NO];
    }];
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
    [self.viewModel.dismissLoadingSignal subscribeNext:^(id x) {
        @strongify(self);
        [self hideLoadingView];
        [KVNProgress dismiss];
    }];
    [self.viewModel.startLoadingSignal subscribeNext:^(id x) {
        
    }];
    [self.viewModel.errorMessageSignal subscribeNext:^(id x) {
        [KVNProgress showErrorWithStatus:MyLocalizedString(@"Technical error. Try again later", nil)];
    }];
    
    [self showSpinner];
    [self.viewModel downloadImagesUpdating:YES];
}

- (void) showSpinner
{
    [self showLoadingView:MyLocalizedString(@"Loading results...", nil)];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
    
    self.photoBrowser.delegate = nil;
    self.photoBrowser = nil;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.viewModel numberOfSections];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection: section];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath: indexPath];
    cell.viewModel = [self.viewModel objectAtIndexPath: indexPath];
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
        _photoBrowser.edgesForExtendedLayout = UIRectEdgeNone;
        _photoBrowser.extendedLayoutIncludesOpaqueBars = NO;
    }
    return _photoBrowser;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    NSUInteger i = [self.viewModel numberOfItemsInSection:0];
    return i;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.viewModel numberOfItemsInSection:0]) {
        ImageViewModel *image = [self.viewModel objectAtIndexPath: [NSIndexPath indexPathForRow:index inSection:0]];
        MWPhoto *photoObj = [MWPhoto photoWithURL: image.url];
        photoObj.caption = image.caption;
        return photoObj;
    }
    return nil;
}

@end

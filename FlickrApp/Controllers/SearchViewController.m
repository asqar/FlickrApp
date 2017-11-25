//
//  SearchViewController.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchViewController.h"
#import "PhotoFetcher.h"
#import "Entities.h"
#import "SearchAttemptCell.h"
#import "SearchResultViewController.h"
#import "DejalActivityView.h"

@interface SearchViewController ()<RBQFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) RBQFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) SVPullToRefreshView *pullToRefreshView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self translateUI];
    // Do any additional setup after loading the view.
        
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.fetchedResultsController performFetch];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
    [self.fetchedResultsController performFetch];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
//    if ([SearchAttempt allObjects].count == 0) {
//        [self.searchBar becomeFirstResponder];
//    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) translateUI
{
    self.title = MyLocalizedString(@"Search", nil);
}

#pragma mark - Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_searchBar.text.length == 0)
        return;
    [_searchBar endEditing:YES];
    NSString *searchStr = self.searchBar.text;
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    
    SearchAttempt *searchAttempt = [[SearchAttempt alloc] init];
    searchAttempt.searchTerm = searchStr;
    searchAttempt.dateSearched = [NSDate date];
    [[RLMRealm defaultRealm] addOrUpdateObject: searchAttempt];
    
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
    SearchResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    vc.searchAttempt = searchAttempt;
    [self.navigationController pushViewController:vc animated:YES];
    
    self.searchBar.text = @"";
}

#pragma mark - Fetched results controller

- (RBQFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        RLMSortDescriptor *sd1 = [RLMSortDescriptor sortDescriptorWithKeyPath:@"dateSearched" ascending:NO];
        NSArray *sortDescriptors = @[ sd1 ];
        
        RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:@"SearchAttempt" inRealm:[RLMRealm defaultRealm] predicate:nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        
        _fetchedResultsController = [[RBQFetchedResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        [_fetchedResultsController performFetch];
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(RBQFetchedResultsController *)controller
{
    [self.tableView reloadData];
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

#pragma mark - UITableView data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController numberOfSections];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController numberOfRowsForSectionIndex: 0];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAttemptCell *cell = (SearchAttemptCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchAttemptCell"];
    SearchAttempt *searchAttempt = [self.fetchedResultsController objectAtIndexPath: indexPath];
    cell.searchAttempt = searchAttempt;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAttempt *searchAttempt = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20.0f * 2 - 156.0f - 35.0f;
    CGFloat height = [searchAttempt.searchTerm boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17.0f]} context:nil].size.height + 20.f;
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SearchResultViewController class]]) {
        SearchAttempt *searchAttempt = [self.fetchedResultsController objectAtIndexPath: self.tableView.indexPathForSelectedRow];
        SearchResultViewController *vc = (SearchResultViewController *) segue.destinationViewController;
        vc.searchAttempt = searchAttempt;
    }
}

@end

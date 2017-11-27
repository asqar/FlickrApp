//
//  SearchViewController.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchAttemptCell.h"
#import "SearchAttemptViewModel.h"
#import "SearchResultViewController.h"
#import "SearchResultViewModel.h"
#import "SearchViewModel.h"

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) SVPullToRefreshView *pullToRefreshView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self translateUI];
    // Do any additional setup after loading the view.
        
    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
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
    
    SearchResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    vc.viewModel = [[SearchResultViewModel alloc] initWithSearchQuery: self.searchBar.text];
    [self.navigationController pushViewController:vc animated:YES];
    
    self.searchBar.text = @"";
}

#pragma mark - UITableView data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection: 0];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAttemptCell *cell = (SearchAttemptCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchAttemptCell"];
    SearchAttemptViewModel *viewModel = [self.viewModel objectAtIndexPath: indexPath];
    cell.viewModel = viewModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAttemptViewModel *searchAttempt = [self.viewModel objectAtIndexPath: indexPath];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20.0f * 2 - 156.0f - 35.0f;
    CGFloat height = [searchAttempt.queryString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17.0f]} context:nil].size.height + 20.f;
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
        SearchAttemptViewModel *searchAttemptViewModel = [self.viewModel objectAtIndexPath: self.tableView.indexPathForSelectedRow];
        SearchResultViewController *vc = (SearchResultViewController *) segue.destinationViewController;
        vc.viewModel = [[SearchResultViewModel alloc] initWithSearchAttemptViewModel:searchAttemptViewModel];
    }
}

@end

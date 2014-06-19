//
//  MoviesListViewController.m
//  iOSRottenTomatoes
//
//  Created by Alex on 6/5/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "MoviesListViewController.h"
#import "RottenTomatoesClient.h"
#import "MovieTableViewCell.h"
#import "MovieDetailViewController.h"
#import "WBErrorNoticeView.h"

#define TAB_BOXOFFICE 1
#define TAB_DVDS 2

@interface MoviesListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RottenTomatoesClient* rtClient;
@property (nonatomic, strong) NSMutableArray *moviesArray;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property UIRefreshControl *refreshControl;
@property (nonatomic, retain) WBErrorNoticeView *errorNotice;
@property UIView *selectionColor;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@end

@implementation MoviesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showNetworkError {
    __weak typeof(self) weakSelf = self;
    
    [self.errorNotice setTitle:NSLocalizedString(@"Network Error", nil)];
    [self.errorNotice setMessage:NSLocalizedString(@"Unable to reach Rotten Tomatoes. Tap here to retry.", nil)];
    [self.errorNotice show];
    [self.errorNotice setDismissalBlock:^(BOOL dismissedInteractively) {
        if (dismissedInteractively) {
            [weakSelf loadData];
        };
    }];
}

- (NSString *)getApiUrl:(NSString*) filter {
    if (![filter isEqualToString:@""]) {
        return [@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=yv49qpxe8yzc7w7vbnr48rnr&q=" stringByAppendingString:[filter stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    }
    
    UITabBarItem *tab = [self.tabBar selectedItem];
    if (tab.tag == TAB_BOXOFFICE) {
        return @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=yv49qpxe8yzc7w7vbnr48rnr";
    }
    else {
        return @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=yv49qpxe8yzc7w7vbnr48rnr";
    }
}

- (void)loadData {
    [self loadData:@""];
}

- (void)loadData:(NSString*) filter {
    [self.errorNotice dismissNotice];
    [self.activityIndicatorView startAnimating];
    
    NSString *url = [self getApiUrl:filter];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // Stop pull to refresh spinner.
        [self.refreshControl endRefreshing];
        
        // Stop activity indicator as well.
        [self.activityIndicatorView stopAnimating];
        
        if (connectionError) {
            [self showNetworkError];
            return;
        }

        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.moviesArray = [object objectForKey:@"movies"];

        if (connectionError || !self.moviesArray.count ) {
            [self showNetworkError];
            return;
        }
        
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    
    self.title = @"Movies";

    self.selectionColor = [[UIView alloc] init];
    self.selectionColor.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(247/255.0) blue:(235/255.0) alpha:1];

    self.errorNotice = [WBErrorNoticeView errorNoticeInView:self.view title:@"" message:@""];
    [self.errorNotice setOriginY:self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y];
    [self.errorNotice setSticky:YES];

    // Implements pull to refresh on the table view.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // Point table view data source and delegates to this class itself.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 95;
    
    // Hide table while data is being fetched.
    self.tableView.hidden = YES;
    
    // Setting Up Activity Indicator View to show spinner while loading.
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    
    [self loadData];
    
    UINib *tableViewNib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.tableView registerNib:tableViewNib forCellReuseIdentifier:@"MovieTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moviesArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.moviesArray[indexPath.row];
    cell.movie = movie;
    
    cell.selectedBackgroundView = self.selectionColor;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *movie = self.moviesArray[indexPath.row];

    MovieDetailViewController *mvc = [[MovieDetailViewController alloc] init];
    mvc.movieDictionary = movie;
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self loadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"text: %@", searchText);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(loadData:) withObject:searchText afterDelay:0.5];
}
@end

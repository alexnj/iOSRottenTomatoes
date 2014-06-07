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

@interface MoviesListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RottenTomatoesClient* rtClient;
@property (nonatomic, strong) NSMutableArray *moviesArray;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property UIRefreshControl *refreshControl;
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

- (void)loadData {
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        self.moviesArray = [object objectForKey:@"movies"];
        [self.activityIndicatorView stopAnimating];
        [self.tableView setHidden:NO];
        [self.tableView reloadData];

        // Stop pull to refresh spinner.
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Box office";

    // Implements pull to refresh on the table view.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // Point table view data source and delegates to this class itself.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // A fixed row height is necessary because Apple cant jackshit?
    self.tableView.rowHeight = 95;
    
    // WTF is this?
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Hide table while data is being fetched.
    self.tableView.hidden = YES;
    
    // Setting Up Activity Indicator View to show spinner while loading.
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    [self loadData];
    
//    self.rtClient = [[RottenTomatoesClient alloc] init];
    
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
    NSLog(@"%@",movie);
    cell.nameLabel.text = movie[@"title"];
;
    
    NSURL *url = [[NSURL alloc] initWithString:movie[@"posters"][@"thumbnail"]];
    [cell.movieThumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *movie = self.moviesArray[indexPath.row];

    MovieDetailViewController *mvc = [[MovieDetailViewController alloc] init];
    mvc.movieDictionary = movie;
    
    [self.navigationController pushViewController:mvc animated:YES];
}

@end

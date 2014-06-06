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

@interface MoviesListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RottenTomatoesClient* rtClient;
@property (nonatomic, strong) NSMutableArray *moviesArray;
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
        
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 164;
    
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
    return cell;
}

@end

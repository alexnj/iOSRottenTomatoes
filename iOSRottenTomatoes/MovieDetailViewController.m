//
//  MovieDetailViewController.m
//  iOSRottenTomatoes
//
//  Created by Alex on 6/7/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSummaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *imageUrl = self.movieDictionary[@"posters"][@"detailed"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.moviePosterImageView.image = [UIImage imageWithData:data];
    }];

    self.movieTitleLabel.text = self.movieDictionary[@"title"];
    self.movieSummaryLabel.text = self.movieDictionary[@"synopsis"];
    
    CGRect titleLabelBounds = self.movieSummaryLabel.bounds;
    titleLabelBounds.size.height = CGFLOAT_MAX;

    CGRect minimumTextRect = [self.movieSummaryLabel textRectForBounds:titleLabelBounds limitedToNumberOfLines:2];
    
    CGFloat titleLabelHeightDelta = minimumTextRect.size.height - self.movieSummaryLabel.frame.size.height;
    CGRect titleFrame = self.movieSummaryLabel.frame;
    titleFrame.size.height += titleLabelHeightDelta;
    self.movieSummaryLabel.frame = titleFrame;

    [self.scrollView setScrollEnabled:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

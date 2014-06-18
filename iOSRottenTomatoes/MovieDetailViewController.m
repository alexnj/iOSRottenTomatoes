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

- (void)finishedLoadingPosterImage:(UIImage *)image {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.moviePosterImageView.layer addAnimation:transition forKey:nil];

    self.moviePosterImageView.image = image;
}

- (void)loadLowQualityPoster:(NSDictionary*)imageArray {
    NSString* lowResImageUrl = imageArray[@"profile"];
    NSString* highResImageUrl = imageArray[@"original"];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:lowResImageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *lowQualityPosterImage = [UIImage imageWithData:data];

        // Update image on the main thread and wait until it returns.
        [self performSelectorOnMainThread:@selector(finishedLoadingPosterImage:) withObject:lowQualityPosterImage waitUntilDone:YES];

        // Upgrade to higher quality now.
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:highResImageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            UIImage *highQualityPosterImage = [UIImage imageWithData:data];

            // Update image on the main thread and wait until it returns.
            [self performSelectorOnMainThread:@selector(finishedLoadingPosterImage:) withObject:highQualityPosterImage waitUntilDone:YES];
        }];

    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Start loading image in a background thread.
    [self performSelectorInBackground:@selector(loadLowQualityPoster:) withObject:self.movieDictionary[@"posters"]];
    
    self.movieTitleLabel.text = self.movieDictionary[@"title"];
    self.movieSummaryLabel.text = self.movieDictionary[@"synopsis"];
    
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

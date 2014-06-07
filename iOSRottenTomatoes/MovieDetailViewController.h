//
//  MovieDetailViewController.h
//  iOSRottenTomatoes
//
//  Created by Alex on 6/7/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSummaryLabel;
@property NSDictionary *movieDictionary;
@end

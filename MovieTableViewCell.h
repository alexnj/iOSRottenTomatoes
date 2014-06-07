//
//  MovieTableViewCell.h
//  iOSRottenTomatoes
//
//  Created by Alex J. on 6/6/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieThumbnail;

@end

//
//  MovieTableViewCell.m
//  iOSRottenTomatoes
//
//  Created by Alex J. on 6/6/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "MovieTableViewCell.h"


@interface MovieTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@end

@implementation MovieTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageOnMainThread:(UIImage *)image
{
    if (!image)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.thumbnailImageView.layer addAnimation:transition forKey:nil];
        
        self.thumbnailImageView.image = image;
    });
}

- (void)setMovie:(NSDictionary *)movie {
    self.movieNameLabel.text = movie[@"title"];
    
    NSString *imageUrl = movie[@"posters"][@"thumbnail"];

    [[TMDiskCache sharedCache] objectForKey:imageUrl
          block:^(TMDiskCache *cache, NSString *key, id object, NSURL* fileUrl) {
              if (object) {
                  UIImage *image = (UIImage *)object;
                  [self setImageOnMainThread:image];
                  
                  NSLog(@"image loaded from cache: %@", imageUrl);
                  return;
              }
              
              [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

                  // Write to cache.
                  [[TMDiskCache sharedCache] setObject:self.thumbnailImageView.image forKey:imageUrl block:nil];
                  UIImage *image = [UIImage imageWithData:data];

                  NSLog(@"image loaded from network: %@", imageUrl);
                  
                  [self setImageOnMainThread:image];
              }];
              
              
          }];

}
@end

//
//  RottenTomatoesClient.h
//  iOSRottenTomatoes
//
//  Created by Alex on 6/5/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface RottenTomatoesClient : AFHTTPRequestOperationManager

+ (RottenTomatoesClient *) instance;

@end

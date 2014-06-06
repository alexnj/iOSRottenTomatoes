//
//  RottenTomatoesClient.m
//  iOSRottenTomatoes
//
//  Created by Alex on 6/5/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "RottenTomatoesClient.h"

@implementation RottenTomatoesClient

+ (RottenTomatoesClient *) instance {
    static dispatch_once_t pred;
    static RottenTomatoesClient *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[RottenTomatoesClient alloc] init];
    });
    
    return shared;
}

@end

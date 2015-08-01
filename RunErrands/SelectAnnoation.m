//
//  SelectAnnoation.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/1.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "SelectAnnoation.h"

@implementation SelectAnnoation

@synthesize coordinate, title, subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate =coord;
    }
    return self;
}

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
    title = @"請拖放大頭針指定位置";
    subtitle = @"subtitle";
}

@end

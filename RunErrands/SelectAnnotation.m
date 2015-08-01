//
//  SelectAnnoation.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/1.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "SelectAnnotation.h"

@implementation SelectAnnotation

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
    //title = [NSString stringWithFormat:@"%f, %f", newCoordinate.latitude, newCoordinate.longitude];
    title = @"拖放的大頭針";
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    CLGeocoder *geocoder = [CLGeocoder new];

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            
            //NSString *message = [NSString stringWithFormat:@"%@", topResult.addressDictionary];
            NSLog(@"%@,  %@,  %@, %@", topResult.country,topResult.subAdministrativeArea, topResult.locality, topResult.name);
            subtitle = [[NSString alloc] initWithFormat:@"%@%@%@", topResult.subAdministrativeArea,topResult.locality, topResult.name];
        }
    }];
    

    
}

@end

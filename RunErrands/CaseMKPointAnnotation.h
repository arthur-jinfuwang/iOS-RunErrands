//
//  CaseMKPointAnnotation.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/26.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface CaseMKPointAnnotation : MKPointAnnotation


@property (nonatomic, strong)PFObject *caseObject;


@end

//
//  SelectAnnoation.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/1.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void(^SendStringBack)(NSString*string);

@interface SelectAnnotation : NSObject <MKAnnotation>

@property (nonatomic,strong)SendStringBack block;

// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
//@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *subAdministrativeArea;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *roadName;

-(id) initWithLocation:(CLLocationCoordinate2D) coord;

@end

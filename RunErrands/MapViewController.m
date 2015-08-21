//
//  MapViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/20.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
    NSArray *caseslist;
}

@property (weak, nonatomic) IBOutlet MKMapView *theMapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    locationManager = [CLLocationManager new];
    // Ask user's permission
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    // Prepare locationManaage
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeOther;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    _theMapView.userTrackingMode = MKUserTrackingModeFollow;
    
#if 1
    PFQuery *query = [PFQuery queryWithClassName:@"Cases"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld case in map view.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
            caseslist = objects;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = locations.lastObject;
    
    NSLog(@"Current Location: %.6f,%.6f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    if (isFirstLocationReceived == false) {
        MKCoordinateRegion region = _theMapView.region;
        region.center = currentLocation.coordinate;
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
        
        [_theMapView setRegion:region animated:true];
        isFirstLocationReceived = true;
        
        // Add Annotation
        CLLocationCoordinate2D coordicate = currentLocation.coordinate;
        coordicate.longitude += 0.005;
        coordicate.latitude += 0.005;
        
        MKPointAnnotation *annotation = [MKPointAnnotation new];

        
        annotation.coordinate = coordicate;
        annotation.title = @"肯德基";
        annotation.subtitle = @"真好吃!🍗";
        
        [_theMapView addAnnotation: annotation];
        
    }
}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if (annotation == mapView.userLocation)
        return nil;
    
    MKPinAnnotationView *resultView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Case"];
    
    
    if(resultView == nil)
    {
        resultView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Case"];
    }else{
        resultView.annotation = annotation;
        
    }
    
    resultView.canShowCallout = true;
    resultView.animatesDrop = true;
    resultView.pinColor = MKPinAnnotationColorGreen;
    
    
    return resultView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

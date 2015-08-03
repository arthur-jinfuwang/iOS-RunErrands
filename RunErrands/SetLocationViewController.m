//
//  SetLocationViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/29.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "SetLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SelectAnnotation.h"
#import "SlideNavigationController.h"

@interface SetLocationViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
}
@property (weak, nonatomic) IBOutlet MKMapView *theMapView;

@end

@implementation SetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (isFirstLocationReceived == false) {
        CLLocation *currentLocation = locations.lastObject;
        
        MKCoordinateRegion region = _theMapView.region;
        region.center = currentLocation.coordinate;
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
        [_theMapView setRegion:region animated:true];
        
        CLLocationCoordinate2D coordicate = currentLocation.coordinate;
        
        SelectAnnotation *annotation = [[SelectAnnotation alloc] initWithLocation:coordicate];
        annotation.coordinate = coordicate;
        
        [_theMapView addAnnotation: annotation];
        
        isFirstLocationReceived =true;
    }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    
//    if (annotation == mapView.userLocation)
//        return nil;
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    MKPinAnnotationView *resultView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Case"];
    
    if(resultView == nil)
    {
        resultView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Case"];
    }else{
        resultView.annotation = annotation;
        
    }
    
    //resultView.canShowCallout = true;
    resultView.draggable = YES;
    resultView.animatesDrop = true;
    resultView.canShowCallout = YES;
    resultView.pinColor = MKPinAnnotationColorGreen;
    
    return resultView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    if (newState == MKAnnotationViewDragStateEnding) {
        view.canShowCallout = YES;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        view.rightCalloutAccessoryView = rightButton;
        
        //return resultView;
    }
}

- (void) buttonPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"確認" message:@"請確認你指定的位置" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:cancel];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        UIViewController *vc ;
        
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"PostCastViewController"];

        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
    }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:true completion:nil];
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

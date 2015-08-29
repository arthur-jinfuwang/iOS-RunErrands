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
#import "CaseDetailsTableViewController.h"
#import "CaseMKPointAnnotation.h"
#import "CaseListTableViewController.h"
#import "MBProgressHUD.h"


@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstLocationReceived;
    NSArray *caselist;
    PFObject *currentObject;
    MBProgressHUD *HUD;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *theListViewBarBtn;

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
    _theMapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _theListViewBarBtn.enabled = false;

    if ([PFUser currentUser]) {
        [self loadCaseDatas];
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未登入" message:@"請先登入你的帳號" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
            [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }
}

-(void) loadCaseDatas
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cases"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld case in map view.", objects.count);

            if (caselist != nil) {
                caselist = nil;
            }
            caselist = [NSArray arrayWithArray:objects];
            for (PFObject *object in caselist) {
                NSLog(@"Map menu view get objects%@", object.objectId);
            }
            isFirstLocationReceived = false;
            _theListViewBarBtn.enabled = true;
            [locationManager startUpdatingLocation];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

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
          NSLog(@"%ld\n", [caselist count]);
    if (isFirstLocationReceived == false) {
        MKCoordinateRegion region = _theMapView.region;
        region.center = currentLocation.coordinate;
        region.span.latitudeDelta = 0.1;
        region.span.longitudeDelta = 0.1;
        
        [_theMapView setRegion:region animated:true];
        isFirstLocationReceived = true;

        // Add Annotation
        CLLocationCoordinate2D coordicate;
        for (PFObject *item in caselist) {
            PFGeoPoint *itemGeoPoint = item[@"work_GeoPoint"];
            if (itemGeoPoint == nil) {
                continue;
            }
            CaseMKPointAnnotation *annotation = [CaseMKPointAnnotation new];

            coordicate.longitude = itemGeoPoint.longitude;
            coordicate.latitude = itemGeoPoint.latitude;
            
            annotation.coordinate = coordicate;
            annotation.title = [NSString stringWithFormat:@"%@:%@",item[@"wage_class"], item[@"wage"]];
            annotation.subtitle = item[@"case_title"];
            [annotation setCaseObject:item];
            
            [_theMapView addAnnotation: annotation];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
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
    resultView.pinColor = MKPinAnnotationColorRed;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    resultView.rightCalloutAccessoryView = rightButton;
    
    return resultView;
}

- (void) buttonPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"確認" message:@"你是否要查看詳細資料" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CaseDetailsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CaseDetailsTableViewController"];
        
        [vc setCaseObject:currentObject];
        [vc setIsEnableFollow:YES];
        
        [[SlideNavigationController sharedInstance] pushViewController:vc animated:YES];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if (view.annotation == mapView.userLocation)
        return;
    
    CaseMKPointAnnotation *object =(CaseMKPointAnnotation *)view.annotation;
    
    currentObject = object.caseObject;
    
    NSLog(@"did select %@", currentObject[@"case_title"]);
}


- (void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"caseListViewSegue"]) {
        
        CaseListTableViewController * vc = segue.destinationViewController;

        [vc setCaselist:caselist];
    }
    
}


- (IBAction)theListViewBtn:(id)sender {
}
@end

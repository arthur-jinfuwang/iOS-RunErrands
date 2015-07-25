//
//  openViewController.m
//  RunErrands
//
//  Created by Tony on 7/21/15.
//  Copyright (c) 2015 Jinfu Wang. All rights reserved.
//

#import "openViewController.h"
#import "MapViewController.h"
#import "SlideNavigationController.h"

@interface openViewController ()

@end

@implementation openViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:[UIImage imageNamed:@"screen@2x(1).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(2).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(3).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(4).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(5).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(6).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(7).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(8).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(9).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(10).png"]];
    self.openanimation.contentMode = UIViewContentModeScaleAspectFill;
    self.openanimation.animationImages = array;
    
    self.openanimation.animationDuration = 0.1;
    
    self.openanimation.animationRepeatCount = 1;
    
    [self.openanimation startAnimating];
    
    
   [self performSelector:@selector(timernextstep) withObject:nil afterDelay:1.6];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) timernextstep{
    
    //跳轉到下個頁面
    /*
    MapViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
 */
   
    //跳轉到下個頁面
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIViewController *vc ;
    
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MapViewController"];
    
    [[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil ];

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

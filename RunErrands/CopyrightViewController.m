//
//  CopyrightViewController.m
//  RunErrands
//
//  Created by Tony on 9/2/15.
//  Copyright (c) 2015 Jinfu Wang. All rights reserved.
//

#import "CopyrightViewController.h"
#import "SlideNavigationController.h"
#import "SettingTableViewController.h"

@interface CopyrightViewController ()

@end

@implementation CopyrightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)MoveButton:(id)sender
{
    [self performSelector:@selector(jumppage) withObject:nil];

}

- (void)jumppage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIViewController *vc ;
    
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SettingTableViewController"];
    
    
    [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];

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

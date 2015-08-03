//
//  LoginViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/25.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LeftMenuViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)FaceookLoginBtn:(id)sender {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    LeftMenuViewController *leftMenu =(LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
        
        NSLog(@"已登入");
        [leftMenu setLoginStatus:USERLOGOUT];
        
        
        //轉至其它畫面...        //Change the slider menu text from login to logout


    }else{
        
        //未登入
        
        [loginManager logInWithReadPermissions:@[@"public_profile",@"email",@"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            NSLog(@"%@",[[[result grantedPermissions]allObjects]description]);
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,name,gender,locale"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *results, NSError *error) {
                 NSLog(@"%@",results);
                 NSLog(@"%@",[results objectForKey:@"email"]);
                 
                 NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/mydata.txt"];
//                 [@"fields":@"email,name,gender,locale" writeToFile:path
//                                                        automically:YES
//                                                           encoding:NSUTF8StringEncoding
//                                                              error:nil];
                 
             }];
            
        }];
        
        //Change the slider menu text from login to logout
        [leftMenu setLoginStatus:USERLOGIN];
        
        //Turn to map view menu

        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController *lc ;
        
        lc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MapViewController"];
        [[SlideNavigationController sharedInstance] switchToViewController:lc withCompletion:nil ];
        

        NSLog(@"not");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"已登入");
        
    }else{
        NSLog(@"未登入");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

 - (BOOL)prefersStatusBarHidden
{
    return YES;
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

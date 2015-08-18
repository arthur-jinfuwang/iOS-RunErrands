//
//  AppDelegate.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/20.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "Reachability.h"

@interface AppDelegate ()
{
    Reachability    *serverReach;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // init the left slide menu
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"evjktl2gwMwsD23fJjiLHlp0pgg2asrXEOJ7p6vk"
                  clientKey:@"7RKd0BPNHWHPtFsdIEKosnO9Fi2vHZKkezYL4fWr"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    if ([PFUser currentUser]) {
        NSLog(@"AppDelgate: You have login!");
        [leftMenu setLoginStatus:USERLOGIN];
    }else
    {
        NSLog(@"AppDelgate: You have logout!");
        [leftMenu setLoginStatus:USERLOGOUT];
    }


    //prepare reachability
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanges:) name:kReachabilityChangedNotification object:nil];
    serverReach = [Reachability reachabilityWithHostName:@"udn.com"];
    //[Reachability reachabilityForInternetConnection];
    [serverReach startNotifier];


    return YES;
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                    didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Reachability detect

-(void) networkStatusChanges:(NSNotification*)notify{
    NetworkStatus   status = [serverReach currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"Not reachable.");

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"無法連上伺服器" message:@"請檢查網路連線是否正確，本程式即將退出" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            exit(0);
        }];
        
        [alert addAction:ok];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];

    }else{
        NSLog(@"Reach with: %ld", status);
        //[self updateNewsList];
    }
}


@end

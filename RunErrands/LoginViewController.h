//
//  LoginViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/25.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationContorllerAnimator.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginViewController : UIViewController <SlideNavigationControllerDelegate>

@property (nonatomic,assign) BOOL networkBroken;

@end

//
//  LeftMenuViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/22.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

typedef NS_ENUM(NSInteger, FUMCTIONMENUS){
    MAPVIEWMENU = 0,
    POSTCASTMENU,
    FOLLOWMENU,
    MESSAGEMENU,
    SETTINGMENU,
    LOGINMENU,
    CASELISTMENU,
};

typedef NS_ENUM(NSInteger, USERLOGINSTATUS){
    USERLOGOUT= 0,
    USERLOGIN,
};

@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

- (void) setLoginStatus:(USERLOGINSTATUS)status;

@end

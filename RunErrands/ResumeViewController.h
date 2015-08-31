//
//  ResumeViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/27.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>

typedef NS_ENUM(NSInteger, RE_USER) {
    RE_USER_NICKNAME,
    RE_USER_GENDER,
    RE_USER_BIRTHDAY,
    RE_USER_PHONE,
    RE_USER_EMAIL,
};

@interface ResumeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *ResumeProfilePic;

- (void) buttonpress:(id) sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFObject  *caseObject;

@end

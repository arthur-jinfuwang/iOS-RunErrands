//
//  SettingTableViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "SettingTableViewCell.h"

typedef NS_ENUM(NSInteger, RE_USER) {
    RE_USERNAME = 0,
    RE_USER_NICKNAME,
    RE_USER_GENDER,
    RE_USER_BIRTHDAY,
    RE_USER_PHONE,
    RE_USER_EMAIL
};

@interface SettingTableViewController : UITableViewController <SlideNavigationControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (void) isEnableLeftBarButtonItem:(BOOL)flag;
@end

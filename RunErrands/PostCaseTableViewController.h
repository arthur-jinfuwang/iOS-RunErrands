//
//  PostCaseTableViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import <Parse/Parse.h>
#import <Parse/PFQuery.h>

typedef NS_ENUM(NSInteger, RE_CASEDETAIL){
    RE_CASE_TITLE = 0 ,
    RE_WORK_PLACE,
    RE_CASE_CONTENT,
    RE_WORK_BEGIN_AT,
    RE_WORK_END_AT,
    RE_WAGE,
    RE_PERSONS,
    RE_DEADLINE,
    RE_CONTACT_NAME,
    RE_CONTACT_PHONE,
    RE_CONTACT_EMAIL,
    
    RE_WAGE_CLASS = 20,
    RE_WORK_CITY,
    RE_WORK_DIST,
    RE_WORK_ROAD
};


@interface PostCaseTableViewController:UITableViewController <SlideNavigationControllerDelegate>

@property (nonatomic, strong)  PFObject *details;

@end

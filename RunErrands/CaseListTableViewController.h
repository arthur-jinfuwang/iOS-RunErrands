//
//  CaseListTableViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/23.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface CaseListTableViewController : UITableViewController <SlideNavigationControllerDelegate>

@property (nonatomic, strong) NSArray *caselist;

@end

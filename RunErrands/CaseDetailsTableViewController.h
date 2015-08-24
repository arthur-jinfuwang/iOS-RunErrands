//
//  CaseDetailsTableViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/27.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface CaseDetailsTableViewController : UITableViewController

@property (nonatomic,strong)PFObject *caseObject;

@end

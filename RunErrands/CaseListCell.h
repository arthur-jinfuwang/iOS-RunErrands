//
//  CaseListCell.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/2.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *theUserIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *theCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *thePostTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWageLabel;
@property (weak, nonatomic) IBOutlet UILabel *theTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *theFollowLabel;

@end

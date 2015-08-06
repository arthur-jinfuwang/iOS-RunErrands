//
//  SettingTableViewCell.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *dataTextField;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@end

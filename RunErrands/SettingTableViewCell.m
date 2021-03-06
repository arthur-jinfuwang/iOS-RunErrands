//
//  SettingTableViewCell.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)dataTextFieldDidEndOnExit:(id)sender {
    [sender resignFirstResponder];
    
    if ([_dataTextField.text length] > 0) {
        _dataLabel.text = _dataTextField.text;
    }
    
    _dataLabel.hidden = NO;
    _dataTextField.hidden = YES;
}


@end

//
//  MessageListCellTableView.h
//  RunErrands
//
//  Created by Tony on 8/3/15.
//  Copyright (c) 2015 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCellTableView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *theUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *theUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *theStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *theTimeLabel;

@end

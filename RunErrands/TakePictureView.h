//
//  TakePictureView.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/9.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TakePictureViewDelegate<NSObject>
@optional
-(void)changePictureView;
@end

@interface TakePictureView : UIView

@property (weak, nonatomic) id<TakePictureViewDelegate>takePicturedViewDlegate;
@property (weak, nonatomic) IBOutlet UILabel *thePictureLabel;
@property (weak, nonatomic) IBOutlet UIButton *thePictureBtn;

@end

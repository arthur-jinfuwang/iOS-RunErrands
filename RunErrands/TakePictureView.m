//
//  TakePictureView.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/9.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "TakePictureView.h"

@implementation TakePictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)thePictureBtnTouchUp:(id)sender {
    NSLog(@"thePictureBtnTouchUp take picture view");
    
    if ([self.takePicturedViewDlegate respondsToSelector:@selector(changePictureView)]) {
        [self.takePicturedViewDlegate changePictureView];
    }
}

@end

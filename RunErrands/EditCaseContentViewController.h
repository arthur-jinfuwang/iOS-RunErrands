//
//  EditCaseContentViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/22.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditedContent)(NSString *content);

@interface EditCaseContentViewController : UIViewController <UITextViewDelegate>

@property (nonatomic,strong)EditedContent editedTextContent;
@property (nonatomic,strong)NSString *textContent;

- (void)setTheEditedContent:(NSString *)content;
@end

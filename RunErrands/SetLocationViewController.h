//
//  SetLocationViewController.h
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/29.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAnnotation.h"


typedef void(^CaseLocation)(SelectAnnotation *location);

@interface SetLocationViewController : UIViewController

@property (nonatomic,strong)CaseLocation returnCaseLocation;

@end

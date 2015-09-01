//
//  CaseTextContentViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/25.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "CaseTextContentViewController.h"

@interface CaseTextContentViewController ()
{
    PFObject *caseObject;
}
@property (weak, nonatomic) IBOutlet UIImageView *theCaseImageView;
@property (weak, nonatomic) IBOutlet UITextView *theCaseContentTextView;

@end

@implementation CaseTextContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (caseObject != nil) {
        [self updateCaseContent];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCaseObject:(PFObject *)object
{
    caseObject = object;
}

- (void) updateCaseContent
{
    NSString *text = caseObject[@"case_content"];
    NSLog(@"The content text: %@", text);
    [_theCaseContentTextView setText:text];
    
    //download
    PFFile *userImageFile = caseObject[@"case_photo"];
    if (userImageFile != nil) {
        
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [_theCaseImageView setImage:image];
            }else
            {
                NSLog(@"%@", error.description);
            }
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  CopyrightViewController.m
//  RunErrands
//
//  Created by Tony on 9/2/15.
//  Copyright (c) 2015 Jinfu Wang. All rights reserved.
//

#import "CopyrightViewController.h"
#import "SlideNavigationController.h"
#import "SettingTableViewController.h"

@interface CopyrightViewController ()
@property (weak, nonatomic) IBOutlet UIButton *theConfirmBtn;

@end

@implementation CopyrightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.enableConfirmBtn) {
        _theConfirmBtn.enabled = YES;
        _theConfirmBtn.hidden = NO;
    }else
    {
        _theConfirmBtn.enabled = NO;
        _theConfirmBtn.hidden =YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)theConfirmBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startRegister" object:nil];

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

//
//  ResumeViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/27.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "ResumeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface ResumeViewController ()<MBProgressHUDDelegate>
{
    NSMutableArray *imagearray;
    NSMutableArray *textarray;
    UIButton *button;
    MBProgressHUD *HUD;
}
@end

@implementation ResumeViewController
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imagearray = [[NSMutableArray alloc] initWithObjects:@"vcard_color_64x64.png",@"ffffound_color_64x64.png",@"tumbrl_color_64x64.png",@"wiki_color_64x64.png","aim_color_64x64", nil];
    
    textarray = [[NSMutableArray alloc] initWithObjects:
                         @"姓名:", @"性別:", @"生日:",@"電話:", @"信箱:",nil];

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    //宣告一個按鈕
    button = [[UIButton alloc]init];
    
    //設定按鈕類型
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //位置,大小
    button.frame = CGRectMake(140,600,100,100);
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    //按鈕文字
    [button setTitle:@"邀請" forState:UIControlStateNormal];
    //攔截按鈕的訊息,並觸發button方法
    [button addTarget:self action:@selector(buttonpress:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resumeCell"];
    
    //cell.dataTextField.delegate = self;
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"SettingCells"owner:nil options:nil];
    
    cell = (SettingTableViewCell *)[view lastObject];
    
    //履歷圖示初始化
    //cell.iconTitle.image = [UIImage imageNamed:imagearray[indexPath.row]];
    
    cell.titleLabel.hidden = NO;
    cell.iconTitle.hidden = YES;
    
    //履歷文字初始化 index.row讀取陣列的資料
    cell.titleLabel.text = textarray[indexPath.row];
    
    switch (indexPath.row) {
        case RE_USER_NICKNAME:
            cell.dataLabel.text = user[@"nickname"];
            break;
        case RE_USER_GENDER:
            cell.dataLabel.text = user[@"gender"];
            break;
        case RE_USER_BIRTHDAY:
            cell.dataLabel.text = user[@"birthday"];
            break;
        case RE_USER_PHONE:
            cell.dataLabel.text = user[@"phone"];
            break;
        case RE_USER_EMAIL:
            cell.dataLabel.text = user[@"email"];
            break;
        default:
            break;
    }
    return cell;
}

 -(void)buttonpress:(id)sender
{
    NSLog(@"button press");
    NSString *ownerID = [PFUser currentUser].objectId;
    NSString *jobSeekerID = self.user.objectId;
    NSString *caseID = self.caseObject.objectId;
    
    PFQuery *query = [PFQuery queryWithClassName:@"ApplyManageTable"];
    [query whereKey:@"owner_id" equalTo:ownerID];
    [query whereKey:@"apply_id" equalTo:jobSeekerID];
    [query whereKey:@"case_id" equalTo:caseID];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 1) {
                PFObject *record = [objects lastObject];
                record[@"status"] = @"邀請";
                [record saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (succeeded) {
                        [button setTitle:@"已邀請" forState:UIControlStateNormal];
                        button.enabled = false;
                    }else
                    {
                        NSLog(@"Resume: saveInBackgroundWithBlock %@",error.description);
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }else
            {
                NSLog(@"ApplyManageTable record neumber error %ld", objects.count);
            }
        }else
        {
            NSLog(@"Resume: findObjectsInBackgroundWithBlock %@",error.description);
        }
    }];

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

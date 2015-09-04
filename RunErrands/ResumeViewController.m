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
    MBProgressHUD *HUD;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *displayinvitedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation ResumeViewController
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imagearray = [[NSMutableArray alloc] initWithObjects:@"vcard_color_64x64.png",@"ffffound_color_64x64.png",@"tumbrl_color_64x64.png",@"wiki_color_64x64.png",@"aim_color_64x64.png", nil];
    
    textarray = [[NSMutableArray alloc] initWithObjects:
                         @"姓名:", @"性別:", @"生日:",@"電話:", @"信箱:",nil];

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [self initResumeStatus];
//    
//    //宣告一個按鈕
//    button = [[UIButton alloc]init];
//    
//    //設定按鈕類型
//    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    //位置,大小
//    button.frame = CGRectMake(115,590,150,100);
//    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont fontWithName:@"GillSans-Light"size:21]];
//    
//    //按鈕文字
//    [button setTitle:@"邀請" forState:UIControlStateNormal];
    //攔截按鈕的訊息,並觸發button方法
//    [button addTarget:self action:@selector(buttonpress:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:button];
    
}


-(void) initResumeStatus
{
    PFQuery *query = [PFQuery queryWithClassName:@"ApplyManageTable"];
    
    [query whereKey:@"apply_id" equalTo:self.user.objectId];
    [query whereKey:@"case_id" equalTo:self.caseObject.objectId];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            PFObject *object = [objects lastObject];
            NSString *status = object[@"status"];
            if ([status isEqualToString:@"應徵"]) {
                
            }else
            {
                self.displayinvitedBtn.enabled = false;
                self.displayinvitedBtn.title = @"已邀請";
            }
        }
        
    }];
    
    PFFile *userImageFile = self.user[@"avatar"];
    
    if (userImageFile != nil)
    {
    
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                if (imageData) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    self.avatarImageView.image = image;
                }
                
            }else
            {
                NSLog(@"%@", error.description);
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
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
    cell.iconTitle.image = [UIImage imageNamed:imagearray[indexPath.row]];
    
    cell.titleLabel.hidden = NO;
    cell.iconTitle.hidden = NO;
    
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
- (IBAction)InviteBtnAction:(id)sender
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
            NSLog(@"ApplyManageTable record neumber error %ld", (unsigned long)objects.count);
            
            for (int i=0; i<(objects.count - 1); i++) {
                PFObject *record = [objects objectAtIndex:i];
                record[@"status"] = @"邀請";
                [record saveInBackground];
            }
            
            PFObject *record = [objects lastObject];
            record[@"status"] = @"邀請";
            [record saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (succeeded) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"應徵訊息" message:@"已發送應徵訊息" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:
                                               ^(UIAlertAction *action)
                                               {
                                                   self.displayinvitedBtn.enabled = false;
                                                   self.displayinvitedBtn.title = @"已邀請";
                                               }];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    NSLog(@"Resume: saveInBackgroundWithBlock %@",error.description);
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }
        else
        {
            NSLog(@"Resume: findObjectsInBackgroundWithBlock %@",error.description);
        }
    }];
    
}




// -(void)buttonpress:(id)sender
//{
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

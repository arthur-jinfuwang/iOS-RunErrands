//
//  MessageTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/25.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "MessageTableViewController.h"
#import "MessageListCellTableView.h"
#import "ResumeViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface MessageTableViewController ()<MBProgressHUDDelegate>
{
    NSMutableArray *caseList;
    NSMutableArray *jobSeekerList;
    MBProgressHUD *HUD;
}

@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([PFUser currentUser] == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未登入" message:@"請先登入你的帳號" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
            [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }else{
        caseList = [NSMutableArray new];
        jobSeekerList= [NSMutableArray new];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadPostCaseDatas];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void) loadPostCaseDatas
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cases"];
    [query whereKey:@"owner_id" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"case_status" equalTo:@"Open"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Post List menu retrieved %ld cases.", objects.count);
            if (objects.count == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你目前沒有管理任何案子" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:true completion:nil];
            }
            else
            {
                //caseList = [[NSMutableArray alloc] initWithArray:objects];
                // Do something with the found objects
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                    [self loadJobSeekersList:object];
                }

            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)loadJobSeekersList:(PFObject *)caseObject
{
    
    PFRelation *relation = [caseObject relationForKey:@"user_apply"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Post List menu retrieved %ld apply cases.", objects.count);
            if (objects.count != 0) {

                [caseList addObject:caseObject];
                [jobSeekerList addObject:objects];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
     NSLog(@"jobSeekerList.count: %ld", jobSeekerList.count);
    return jobSeekerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger number;
    NSArray *jobSeekers = jobSeekerList[section];
    number = [jobSeekers count];
    NSLog(@"numberOfRowsInSection: %ld, %ld", section, number);
    
    return number;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    PFObject *object = caseList[section];
    header = object[@"case_title"];

    return header;
}


//生成另外頁面的物件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCellTableView *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:nil options:nil];
    cell = (MessageListCellTableView *)[view lastObject];
    
    NSMutableArray *jobSeekersArray = jobSeekerList[indexPath.section];
    PFUser *user = jobSeekersArray[indexPath.row];
    
    NSLog(@"nickname: %@", user[@"nickname"]);
    cell.theUserNameLabel.text = user[@"nickname"];
    //cell.theStatusLabel = @"";
    //cell.theTimeLabel = @"";
    
    PFFile *userImageFile = user[@"avatar"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                   cell.theUserImageView.image = image;
            }
            
        }else
        {
            NSLog(@"%@", error.description);
        }
    }];
    
    return cell;
}

//點擊會去讀取下一個頁面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* viewType = @"ResumeViewController";
    ResumeViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewType];
    NSMutableArray *jobSeekersArray = jobSeekerList[indexPath.section];
    PFUser *user = jobSeekersArray[indexPath.row];
    PFObject *object = caseList[indexPath.section];
    
    [viewController setUser:user];
    [viewController setCaseObject:object];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

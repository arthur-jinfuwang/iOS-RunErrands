//
//  PostListTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/3.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "PostListTableViewController.h"
#import <Parse/Parse.h>
#import <Parse/PFQuery.h>
#import "MBProgressHUD.h"

@interface PostListTableViewController ()
{
    NSMutableArray *caseList;
    MBProgressHUD *HUD;
}

@end

@implementation PostListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([PFUser currentUser] == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未登入" message:@"請先登入你的帳號" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
            [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }else{
        [self loadParseDatas];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"dataReload" object:nil];
}

-(void) reloadTableView
{
    [self loadParseDatas];
    [self.tableView reloadData];
}
                           
-(void) loadParseDatas
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cases"];
    [query whereKey:@"owner_id" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"case_status" equalTo:@"Open"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
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
                caseList = [[NSMutableArray alloc] initWithArray:objects];
                // Do something with the found objects
                for (PFObject *object in caseList) {
                    NSLog(@"%@", object.objectId);
                }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return caseList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postListCell" forIndexPath:indexPath];
    
    PFObject *item = caseList[indexPath.row];
    UIFont *font = [ UIFont fontWithName: @"Arial" size: 20.0 ];
    [cell.textLabel setFont:font];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"[標題] %@", item[@"case_title"]];
    
    UIFont *subfont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    [cell.detailTextLabel setFont:subfont];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"[截止時間] %@", item[@"deadline"]];
    NSLog(@"---SSSSS %@", item.objectId);
    // Configure the cell...
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


- (void) removeRelationApplyRecords:(NSString *)objectID
{
    PFQuery *query = [PFQuery queryWithClassName:@"ApplyManageTable"];
    NSString *ownerID = [PFUser currentUser].objectId;
    [query whereKey:@"owner_id" equalTo:ownerID];
    [query whereKey:@"case_id" equalTo:objectID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            if (objects.count > 0) {
                for (PFObject *object in objects) {
                    NSLog(@"removeRelationApplyRecords: %@", object.objectId);
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        if(succeeded)
                        {
                            NSLog(@"removeRelationApplyRecords: %@", object.objectId);
                        }else
                        {
                            NSLog(@"removeRelationApplyRecords: %@", error.description);
                        }
                    }];
                }
            }else{
                NSLog(@"removeRelationApplyRecords: No record");
            }
        }else
        {
            NSLog(@"removeRelationApplyRecords: %@", error.description);
        }
    }];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

        PFObject *object = caseList[indexPath.row];
        
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                NSLog(@"Remove the post case ID: %@ successfully", object.objectId);
                [self removeRelationApplyRecords:object.objectId];
                
            }else{
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        
        }];
        
        [caseList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"editCaseContent"])
    {
        return;
    }else
    {
        CaseDetailsTableViewController * vc = segue.destinationViewController;
        NSInteger row = [self.tableView indexPathForSelectedRow].row;
        PFObject * item = caseList[row];
        [vc setEnableFollowBtn:NO];
        [vc setEnableApplyBtn:NO];
        [vc setEnableContactInfo:YES];
        vc.caseObject = item;
    }
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"dataReload"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

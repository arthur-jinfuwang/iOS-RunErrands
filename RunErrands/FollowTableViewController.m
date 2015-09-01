//
//  FollowTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/25.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "FollowTableViewController.h"
#import "CaseListCell.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "CaseDetailsTableViewController.h"

@interface FollowTableViewController ()<MBProgressHUDDelegate>
{
    
    NSMutableArray  *followList;
    NSMutableArray  *applyList;
    NSMutableArray  *applyStatus;
    MBProgressHUD *HUD;
}

@end

@implementation FollowTableViewController

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
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self loadApplyRecords];
        [self loadFollowsRecords];
        [self loadApplyStatus];
    }
}

- (void) loadApplyStatus
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"ApplyManageTable"];
    [query whereKey:@"apply_id" equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            applyStatus = [[NSMutableArray alloc] initWithArray:objects];
        }else
        {
            NSLog(@"Resume: findObjectsInBackgroundWithBlock %@",error.description);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];

}


-(void) loadApplyRecords
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"user_apply"];
    PFQuery *query = [relation query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Post List menu retrieved %ld apply cases.", objects.count);
            if (objects.count == 0) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你目前沒有應徵任何案子" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
//                [alert addAction:ok];
//                [self presentViewController:alert animated:true completion:nil];
            }
            else
            {
                applyList = [[NSMutableArray alloc] initWithArray:objects];
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}


-(void) loadFollowsRecords
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"user_follows"];
    PFQuery *query = [relation query];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Post List menu retrieved %ld follow cases.", objects.count);
            if (objects.count == 0) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你目前沒有追蹤任何案子" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
//                [alert addAction:ok];
//                [self presentViewController:alert animated:true completion:nil];
            }
            else
            {
                followList = [[NSMutableArray alloc] initWithArray:objects];
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


/*
-(void) loadFollowsRecords
{
    PFQuery *query = [PFQuery queryWithClassName:@"Follows"];
    [query whereKey:@"user_id" equalTo:[PFUser currentUser].objectId];
    
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
                [self loadCaseDatasfromParse:objects];

            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

 
 
- (void) loadCaseDatasfromParse: (NSArray *) records
{
    PFQuery *query = [PFQuery queryWithClassName:@"Cases"];
    for (PFObject *object in records) {
        NSLog(@"%@", object[@"case_id"]);
        [query whereKey:@"objectId" equalTo:object[@"case_id"]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            NSLog(@"Follows menu retrieved %ld cases.", objects.count);
            if (objects.count == 0) {
                NSLog(@"Error!! Data no sync");
            }
            else
            {
                followList = [[NSMutableArray alloc] initWithArray:objects];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
}

*/

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger count;
    
    switch (section) {
        case 0:
            count = [applyList count];
            break;
        case 1:
            count = [followList count];
            break;
        default:
            break;
    }
    
    return count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    switch (section) {
        case 0:
            //header = @"應徵案件";
            header = [[NSString alloc] initWithFormat:@"應徵案件: %ld", [applyList count]];
            break;
        case 1:
            //header = @"追蹤案件";
            header = [[NSString alloc] initWithFormat:@"追蹤案件: %ld", [followList count]];
            break;
        default:
            break;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"caseCell"];
    
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"CaseListCell" owner:nil options:nil];
    cell = (CaseListCell *)[view lastObject];
    
    if (indexPath.section == 0) {
        PFObject *object = applyList[indexPath.row];
        NSString *caseID = object.objectId;
        NSString *userID = [PFUser currentUser].objectId;
        
        for (PFObject *status in applyStatus) {
            if ([userID isEqualToString:status[@"apply_id"]] && [caseID isEqualToString:status[@"case_id"]]) {
                NSString *strStatus = status[@"status"];
                if ([strStatus isEqualToString:@"應徵"]) {
                    cell.theFollowLabel.text = @"❤️";
                    cell.theCityLabel.text = @"應徵中";
                }else
                {
                    cell.theFollowLabel.text = @"✅";
                    cell.theCityLabel.text = @"已受邀";
                }
            }
        }
        
        //cell.theCityLabel.text = object[@"work_city"];
        
        cell.thePostTimeLabel.text =object[@""];
        cell.theTitleLabel.text = object[@"case_title"];
        NSString *wage = [NSString stringWithFormat:@"%@: %@", object[@"wage_class"], object[@"wage"]];
        cell.theWageLabel.text = wage;
        cell.theUserIDLabel.text = object[@"contact_name"];
        //download
        PFFile *imageFile = object[@"case_photo"];
        if (imageFile != nil) {
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    [cell.theImageView setImage:image];
                }else
                {
                    NSLog(@"%@", error.description);
                }
            }];
        }

    }else
    {
        PFObject *object = followList[indexPath.row];
        
        cell.theCityLabel.text = object[@"work_city"];
        cell.theFollowLabel.hidden = YES;
        
        cell.thePostTimeLabel.text =object[@""];
        cell.theTitleLabel.text = object[@"case_title"];
        NSString *wage = [NSString stringWithFormat:@"%@: %@", object[@"wage_class"], object[@"wage"]];
        cell.theWageLabel.text = wage;
        cell.theUserIDLabel.text = object[@"contact_name"];
        //download
        PFFile *imageFile = object[@"case_photo"];
        if (imageFile != nil) {
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    [cell.theImageView setImage:image];
                }else
                {
                    NSLog(@"%@", error.description);
                }
            }];
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString* viewType = @"CaseDetailsTableViewController";
    
    CaseDetailsTableViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewType];
    
    
    PFObject * object;
    switch (indexPath.section) {
        case 0:
        {
            object = applyList[indexPath.row];
            NSString *caseID = object.objectId;
            NSString *userID = [PFUser currentUser].objectId;
            
            [viewController setEnableFollowBtn:YES];
            [viewController setEnableApplyBtn:NO];
            // Will add judage function
            for (PFObject *status in applyStatus) {
                if ([userID isEqualToString:status[@"apply_id"]] && [caseID isEqualToString:status[@"case_id"]]) {
                    NSString *strStatus = status[@"status"];
                    if ([strStatus isEqualToString:@"應徵"]) {
                         [viewController setEnableContactInfo:NO];
                    }else
                    {
                         [viewController setEnableContactInfo:YES];
                    }
                }
            }
            break;
        }
        case 1:
            object = followList[indexPath.row];
            [viewController setEnableFollowBtn:YES];
            [viewController setEnableApplyBtn:YES];
            [viewController setEnableContactInfo:NO];
            break;
        default:
            break;
    }
    viewController.caseObject = object;
    [self.navigationController pushViewController:viewController animated:YES];
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source


        PFUser *user = [PFUser currentUser];
        PFObject *caseObject;
        PFRelation *userFollows = [user relationForKey:@"user_follows"];


        switch (indexPath.section) {
            case 0:
                NSLog(@"setction:%ld rows: %ld\n", indexPath.section, indexPath.row);
                caseObject = applyList[indexPath.row];
                [self removeRelationApplyRecords:caseObject];
                [applyList removeObjectAtIndex:indexPath.row];
                break;
            case 1:
                NSLog(@"setction:%ld rows: %ld\n", indexPath.section, indexPath.row);
                caseObject = followList[indexPath.row];
                [userFollows removeObject:caseObject];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (succeeded) {

                    }else
                    {
                        NSLog(@"removeFollowsArray: %@", error.description);
                    }
                }];
                [followList removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) removeRelationApplyRecords:(PFObject *)caseObject
{
    PFUser *user = [PFUser currentUser];
    PFRelation *userApply = [user relationForKey:@"user_apply"];
    PFRelation *caseApply = [caseObject relationForKey:@"user_apply"];

    [caseApply removeObject:user];
    [userApply removeObject:caseObject];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            
        }else
        {
             NSLog(@"removeRelationApplyRecords: %@", error.description);
        }
    }];
    
    [caseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            
        }else
        {
            NSLog(@"removeRelationApplyRecords: %@", error.description);
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ApplyManageTable"];
    //[query whereKey:@"owner_id" equalTo:caseObject[@"owner_id"]];
    [query whereKey:@"case_id" equalTo:caseObject.objectId];
    [query whereKey:@"apply_id" equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            if (objects.count > 0) {
                for (PFObject *object in objects) {
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        if (succeeded) {
                            NSLog(@"removeRelationApplyRecords: %@", object.objectId);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

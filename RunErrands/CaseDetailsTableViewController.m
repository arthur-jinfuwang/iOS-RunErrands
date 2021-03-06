//
//  CaseDetailsTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/27.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "CaseDetailsTableViewController.h"
#import "CaseTextContentViewController.h"
#import "MBProgressHUD.h"

@interface CaseDetailsTableViewController () <MBProgressHUDDelegate>
{
    NSMutableArray *listDetails;
    MBProgressHUD *HUD;
    BOOL    toFollow;
    BOOL    toApply;
    NSString *applyStatus;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *theApplyCaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *thePostTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *theFollowCaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *theCaseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkTimeBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWageLabel;
@property (weak, nonatomic) IBOutlet UILabel *thePersonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *theDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWageClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *theContactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *theContacePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *theEmailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *theOwnerImageView;
@property (weak, nonatomic) IBOutlet UILabel *theUserIDLabel;

@end

@implementation CaseDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    listDetails = [[NSMutableArray alloc]initWithObjects:
                   @"工作起始時間",@"工作結束時間",@"薪資",@"地點",@"工作內容",@"需求人數",
                   @"截止日期",nil];
    
    if (self.enableFollowBtn == false)
    {
        self.theFollowCaseBtn.hidden = true;
    }
    if (self.enableApplyBtn == false)
    {
        self.theApplyCaseBtn.enabled = false;
        self.theApplyCaseBtn.title = @"";
    }
    
    if (self.caseObject == nil) {
        NSLog(@"There is not any case specified object!");
    }else
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //[self getApplyStatus];
        [self getApplyStatusRecord];
        [self initCellDetailFromCaseObject];
        [self getCaseOwnerInfo];
        [self.navigationController.view addSubview:HUD];
    }
}

- (void) getApplyStatusRecord
{
    PFUser *user = [PFUser currentUser];
    if(user == nil)
        return;
    
    PFQuery *query = [PFQuery queryWithClassName:@"ApplyManageTable"];
    [query whereKey:@"apply_id" equalTo:user.objectId];
    [query whereKey:@"case_id" equalTo:self.caseObject.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                PFObject *object = [objects lastObject];
                applyStatus = object[@"status"];
                self.enableApplyBtn = false;
                self.theApplyCaseBtn.enabled = false;
                if ([applyStatus isEqualToString:@"應徵"]) {
                    [_theFollowCaseBtn setTitle:@"應徵中❤️" forState:UIControlStateNormal];
                }else
                {
                    [_theFollowCaseBtn setTitle:@"已受邀✅" forState:UIControlStateNormal];
                    self.enableContactInfo = YES;
                }
                toApply = true;
                toFollow = false;
            }else
            {
                [self updateFollowStatus];
            }
        }else
        {
            NSLog(@"CaseDetails: findObjectsInBackgroundWithBlock %@",error.description);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

/*
- (void) getApplyStatus
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"user_apply"];
    PFQuery *query = [relation query];
    query = [query whereKey:@"objectId" equalTo:self.caseObject.objectId];
    //NSLog(@"get is following status: %ld", [query countObjects]);
    
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error){
        if (count) {
            self.enableApplyBtn = false;
            self.theApplyCaseBtn.enabled = false;
            [_theFollowCaseBtn setTitle:@"應徵中❤️" forState:UIControlStateNormal];
            toApply = true;
            toFollow = false;
        }else
        {
            [self updateFollowStatus];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
*/

- (void) getCaseOwnerInfo
{
    PFQuery * query = [PFUser query];
    NSString *ownerID = self.caseObject[@"owner_id"];
    [query whereKey:@"objectId" equalTo:ownerID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFUser *owner= [objects lastObject];
            self.theUserIDLabel.text = owner[@"nickname"];
            PFFile *userImageFile = owner[@"avatar"];
            if (userImageFile != nil) {
                
                [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:imageData];
                        [_theOwnerImageView setImage:image];
                    }else
                    {
                        NSLog(@"%@", error.description);
                    }
                    
                }];
            }
        }else
        {
            NSLog(@"getCaseOwnerInfo Error: %@", error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (void) initCellDetailFromCaseObject
{
    //For User content
    
        //self.theUserIDLabel.text = self.caseObject[@"nickname"];
    // For Case object content
    NSString *address = [NSString stringWithFormat:@"%@%@%@",
                         self.caseObject[@"work_city"],
                         self.caseObject[@"work_dist"],
                         self.caseObject[@"work_road"]];
    
    //self.caseObject[@"work_GeoPoint"];
    
    self.theWorkPlaceLabel.text = address;
    
    self.theCaseTitleLabel.text = self.caseObject[@"case_title"];

    self.theWorkTimeBeginLabel.text = self.caseObject[@"work_begin_at"];
    
    self.theWorkEndTimeLabel.text = self.caseObject[@"work_end_at"];
    
    self.theWageLabel.text = self.caseObject[@"wage"];
    
    self.thePersonsLabel.text = self.caseObject[@"persons"];
    
    self.theDeadlineLabel.text = self.caseObject[@"deadline"];
 
    self.theWorkContentLabel.text = self.caseObject[@"case_content"];

    self.theContactNameLabel.text = self.caseObject[@"contact_name"];
    
    self.theContacePhoneLabel.text = self.caseObject[@"contact_phone"];
    
    self.theEmailLabel.text = self.caseObject[@"contact_email"];
    
    self.theWageClassLabel.text = self.caseObject[@"wage_class"];
    
    NSDate *postDate = self.caseObject[@"post_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.thePostTimeLabel.text = [formatter stringFromDate:postDate];
    
}

- (void) updateFollowStatus{
    PFUser *user = [PFUser currentUser];
    if(user == nil)
        return;
    PFRelation *relation = [user relationForKey:@"user_follows"];
    PFQuery *query = [relation query];
    query = [query whereKey:@"objectId" equalTo:self.caseObject.objectId];
    
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error){
        if (count) {
            NSLog(@"get follow status is true");
            [_theFollowCaseBtn setTitle:@"追蹤中💚" forState:UIControlStateNormal];
            toFollow = true;
        }else
        {
            if (error) {
                NSLog(@"updateFollowStatus Error: %@", error.description);
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}


/*
- (void) getFollowsStatus
{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Follows"];
    [query whereKey:@"user_id" equalTo:user.objectId];
    [query whereKey:@"case_id" equalTo:self.caseObject.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld case in map view.", objects.count);
            
            if (objects.count > 0) {
                PFObject *object = [objects lastObject];
                NSString *str = object[@"status"];
                NSLog(@"follows status: %@", str);
                if ([str isEqualToString:@"追蹤中"]) {
                    [_theFollowCaseBtn setTitle:@"追蹤中💚" forState:UIControlStateNormal];
                }
            }

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
*/

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
    if (self.enableContactInfo) {
        return 12;
    }else
    {
        return 9;
    }
}


- (void)processApplytoParse
{
    NSLog(@"Save the apply relations");
    
    PFUser *user = [PFUser currentUser];
    
    PFRelation *userFollows = [user relationForKey:@"user_follows"];
    PFRelation *userApply = [user relationForKey:@"user_apply"];
    
    [userApply addObject:self.caseObject];
    if (toFollow) {
        [userFollows removeObject:self.caseObject];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            
            PFRelation *caseApply = [self.caseObject relationForKey:@"user_apply"];
            [caseApply addObject:user];
            
            [self.caseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (succeeded) {
                    NSLog(@"Save in parse case successed");
                    [self processApplyManageTableStatus];
                }else
                {
                    NSLog(@"%@", error.description);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
            
            
        }else
        {
            NSLog(@"%@", error.description);
            toApply = false;
            _theApplyCaseBtn.enabled = true;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    
}

- (void)processApplyManageTableStatus
{
    PFUser *user = [PFUser currentUser];
    PFObject *applyRecord= [PFObject objectWithClassName:@"ApplyManageTable"];
    applyRecord[@"owner_id"] = self.caseObject[@"owner_id"];
    applyRecord[@"apply_id"] = user.objectId;
    applyRecord[@"case_id"] = self.caseObject.objectId;
    applyRecord[@"status"] = @"應徵";
    [applyRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            NSLog(@"Save in parse ApplyManageTable successed");
            [_theFollowCaseBtn setTitle:@"應徵中❤️" forState:UIControlStateNormal];
            
        }else
        {
            NSLog(@"%@", error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (IBAction)applyBtnPressed:(id)sender {
    PFUser *user = [PFUser currentUser];
    if(user == nil)
        return;
    if (toApply) {
        return;
    }
    
    toApply = true;
    _theApplyCaseBtn.enabled = false;
    [self processApplytoParse];

}

- (IBAction)followBtnPressed:(id)sender {
    NSLog(@"Save the follow relations");
    if (toApply) {
        return;
    }
    PFUser *user = [PFUser currentUser];
    if(user == nil)
        return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _theFollowCaseBtn.enabled = false;
    
    PFRelation *userFollows = [user relationForKey:@"user_follows"];
    if (!toFollow)
    {
        [userFollows addObject:self.caseObject];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                [_theFollowCaseBtn setTitle:@"追蹤中💚" forState:UIControlStateNormal];
                toFollow = true;
            }
            _theFollowCaseBtn.enabled = true;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else
    {
        [userFollows removeObject:self.caseObject];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                [_theFollowCaseBtn setTitle:@"加入追蹤💙" forState:UIControlStateNormal];
                toFollow = false;
            }
            _theFollowCaseBtn.enabled = true;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"caseDetailCell" forIndexPath:indexPath];
    
    cell.textLabel.text = listDetails[indexPath.row];
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.identifier isEqualToString:@"showCaseContent"])
    {
        CaseTextContentViewController * vc = segue.destinationViewController;
        [vc setCaseObject:_caseObject];
    }
    
}

@end

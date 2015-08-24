//
//  CaseDetailsTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/27.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "CaseDetailsTableViewController.h"

@interface CaseDetailsTableViewController ()
{
    NSMutableArray *listDetails;
}
@property (weak, nonatomic) IBOutlet UILabel *theUserIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *thePostTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *theTraceCaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *theCaseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkTimeBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWorkEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWageLabel;
@property (weak, nonatomic) IBOutlet UILabel *thePersonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *theDeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *theWageClassLabel;



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
    if (self.caseObject == nil) {
        NSLog(@"There is not any case specified object!");
    }else
    {
        [self initCellDetailFromCaseObject];
    }
    
}

- (void) initCellDetailFromCaseObject
{
    
    self.theCaseTitleLabel.text = self.caseObject[@"case_title"];

    self.theWorkTimeBeginLabel.text = self.caseObject[@"work_begin_at"];
    
    self.theWorkEndTimeLabel.text = self.caseObject[@"work_end_at"];
    
    self.theWageLabel.text = self.caseObject[@"wage"];
    
    self.thePersonsLabel.text = self.caseObject[@"persons"];
    
    self.theDeadlineLabel.text = self.caseObject[@"deadline"];
    
    self.theUserIDLabel.text = self.caseObject[@"nickname"];
    
//    self.caseObject[@"contact_name"];
//    
//    self.caseObject[@"contact_phone"];
//    
//    self.caseObject[@"contact_email"];
    
        //self.caseObject[@"wage_class"];
        //self.caseObject[@"work_GeoPoint"];
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
    return 9;
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

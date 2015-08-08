//
//  PostCaseTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "PostCaseTableViewController.h"
#import "SettingTableViewCell.h"

@interface PostCaseTableViewController ()
{
    NSMutableArray *listDetails;
}

@end

@implementation PostCaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    listDetails = [[NSMutableArray alloc]initWithObjects:
                   @"設定標題",@"設定地點",@"詳細內容",@"起始時間",@"結束時間",@"薪資",
                   @"需求人數",@"截止日期",@"聯絡人",@"聯絡電話",@"Email",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
       UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.tableView.frame.size.width, 0)];
        view.backgroundColor = [UIColor clearColor];
        view.backgroundColor = [UIColor greenColor];
        return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return listDetails.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"SettingCells" owner:nil options:nil];
    cell = (SettingTableViewCell *)[view lastObject];
    cell.titleLabel.text = listDetails[indexPath.row];
    
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        datePicker.minuteInterval = 5;
        datePicker.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == 7) {
            datePicker.datePickerMode = UIDatePickerModeDate;
        }else{
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        }
        [datePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
        cell.dataTextField.inputView = datePicker;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *cellArray = [tableView visibleCells];
    
    SettingTableViewCell *cell = cellArray[indexPath.row];

    cell.dataLabel.hidden = YES;
    cell.dataTextField.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    NSArray *cellArray = [tableView visibleCells];
    
    SettingTableViewCell *cell = cellArray[indexPath.row];
    cell.dataLabel.text = cell.dataTextField.text;
    cell.dataLabel.hidden = NO;
    cell.dataTextField.hidden = YES;
}


- (void) dateUpdated:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.tableView.indexPathForSelectedRow.row == 7) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    NSArray *cellArray = [self.tableView visibleCells];
    SettingTableViewCell *cell = cellArray[self.tableView.indexPathForSelectedRow.row];
    cell.dataTextField.text = [formatter stringFromDate:datePicker.date];
    NSLog(@"時間為：%@", [formatter stringFromDate:datePicker.date]);
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

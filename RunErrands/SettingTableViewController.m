//
//  SettingTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()<UITextFieldDelegate>
{
    NSMutableArray *settingDetailList;
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    settingDetailList = [[NSMutableArray alloc] initWithObjects:
                         @"姓名", @"暱稱", @"性別", @"手機", @"電子信箱",nil];
    
    
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return settingDetailList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
//    cell.dataTextField.delegate = self;
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"SettingCells" owner:nil options:nil];
    cell = (SettingTableViewCell *)[view lastObject];
    
    cell.titleLabel.text = settingDetailList[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *cellArray = [tableView visibleCells];
    
    SettingTableViewCell *cell = cellArray[indexPath.row];
    
    if (indexPath.row == 2) {
        [cell.dataTextField setUserInteractionEnabled:NO];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"請選擇性別" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男性" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            cell.dataLabel.text = @"男性";
            cell.dataTextField.text = @"男性";
        }];
        UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女性" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            cell.dataLabel.text = @"女性";
            cell.dataTextField.text = @"女性";
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:manAction];
        [alertController addAction:femaleAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    cell.dataLabel.hidden = YES;
    cell.dataTextField.hidden = NO;
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    NSArray *cellArray = [tableView visibleCells];
    
    SettingTableViewCell *cell = cellArray[indexPath.row];
    
    cell.dataLabel.hidden = NO;
    cell.dataTextField.hidden = YES;
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    
//}

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

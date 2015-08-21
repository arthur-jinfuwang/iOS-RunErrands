//
//  PostCaseTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "PostCaseTableViewController.h"
#import "SettingTableViewCell.h"
#import "TakePictureView.h"
#import "SetLocationViewController.h"
#import <Parse/Parse.h>
#import <Parse/PFQuery.h>


@interface PostCaseTableViewController ()<TakePictureViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *listDetails;
    TakePictureView *casePicture;
    UIDatePicker *datePicker;
    PFObject *details;
    PFGeoPoint *caseLocation;
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
    casePicture = [[[NSBundle mainBundle] loadNibNamed:@"TakePictureView" owner:nil options:nil] lastObject];
    casePicture.thePictureLabel.text = @"設定工作相關的照片";
    casePicture.takePicturedViewDlegate = self;
    
    //Date Picker init
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    
    // Init the parse object "Cases"
    details = [PFObject objectWithClassName:@"Cases"];
    details[@"owner_id"] = [PFUser currentUser];
    details[@"case_status"] = @"Editing";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return casePicture;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
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
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row > (listDetails.count - 1)) {
        return;
    }
    NSArray *cellArray = [tableView visibleCells];
    
    SettingTableViewCell *cell = cellArray[indexPath.row];
    
    switch(indexPath.row)
    {
        case RE_WORK_PLACE:{
            [cell.dataTextField setUserInteractionEnabled:NO];
            SetLocationViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetLocationViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case RE_CASE_CONTENT:{
            [cell.dataTextField setUserInteractionEnabled:NO];
            UIViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCaseDetailContent"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }

        case RE_WAGE:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"請選擇薪資類型" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *hourType = [UIAlertAction actionWithTitle:@"時薪" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.titleLabel.text = @"時薪";
            }];
            
            UIAlertAction *dayType = [UIAlertAction actionWithTitle:@"日薪" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.titleLabel.text = @"日薪";
            }];
                
            UIAlertAction *totalType = [UIAlertAction actionWithTitle:@"總金額" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    cell.titleLabel.text = @"總金額";
            }];
            //[alertController addAction:cancelAction];
            [alertController addAction:hourType];
            [alertController addAction:dayType];
            [alertController addAction:totalType];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        default:{
            cell.dataLabel.hidden = YES;
            cell.dataTextField.hidden = NO;
            break;
        }
    }
    
    if (indexPath.row == RE_WORK_BEGIN_AT || indexPath.row == RE_WORK_END_AT || indexPath.row == RE_DEADLINE) {
        
        if (indexPath.row == RE_DEADLINE) {
            datePicker.datePickerMode = UIDatePickerModeDate;
        }else{
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        }
        
        [cell.dataTextField setInputView:datePicker];
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor colorWithRed: 1.0 green: 0.5781 blue: 0.0 alpha: 1.0]];
        [toolBar setTranslucent:YES];
        [toolBar setBackgroundColor:[UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishDataUpdate)];
        
        
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [cell.dataTextField setInputAccessoryView:toolBar];
    }


}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    if (indexPath.row > (listDetails.count - 1)) {
        return;
    }
    NSArray *cellArray = [tableView visibleCells];
    SettingTableViewCell *cell = cellArray[indexPath.row];
    
    if([cell.dataTextField.text length] > 0){
        cell.dataLabel.text = cell.dataTextField.text;
    }
    cell.dataLabel.hidden = NO;
    cell.dataTextField.hidden = YES;
    
}

- (void) finishDataUpdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.tableView.indexPathForSelectedRow.row == 7) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSArray *cellArray = [self.tableView visibleCells];
    SettingTableViewCell *cell = cellArray[self.tableView.indexPathForSelectedRow.row];
    cell.dataTextField.text = [formatter stringFromDate:datePicker.date];
    [cell.dataTextField resignFirstResponder];
    NSLog(@"時間為：%@", [formatter stringFromDate:datePicker.date]);
}


- (void)changePictureView{
    NSLog(@"Change Picture in setting menu");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"請選擇相片來源" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"拍張照吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePictureFromCamera];
    }];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"從相簿選取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPictureFromLibrary];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:manAction];
    [alertController addAction:femaleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取得使用者拍攝照片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //存檔
    //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    
    casePicture.thePictureBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [casePicture.thePictureBtn setImage:image forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePictureFromCamera{
    
    //檢查是否有裝配相機
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        //設定來源是否為相機
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //設定imagePicker的Delegate為Viewcontroller
        imagePicker.delegate =self;
        
        //開啟相機介面
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void)selectPictureFromLibrary{
    
    UIPopoverPresentationController *popover;
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    
    //set source of the picture is from library
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    //set the view mode is popover
    imagePicker.modalPresentationStyle = UIModalPresentationPopover;
    popover = imagePicker.popoverPresentationController;
    
    //set popover window and view conponent have relativate
    popover.sourceView = casePicture;
    // handle the popover arrow
    popover.sourceRect = casePicture.bounds;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Process data to remote server

- (void) saveCaseDetailsToRemoteServer{
    
    NSArray *cellArray = [self.tableView visibleCells];
    
    SettingTableViewCell *cell = nil;
    
    
    
    for (int i=0; i < listDetails.count; i++) {
        
        cell = cellArray[i];
        if( [cell.dataTextField.text length] > 0)
        {
            switch(i)
            {
                case RE_CASE_TITLE:
                    details[@"case_title"] = cell.dataTextField.text;
                    break;
                case RE_WORK_PLACE:
                    //details[@"work_GeoPoint"] =;
                    break;
                case RE_CASE_CONTENT:
                    break;
                case RE_WORK_BEGIN_AT:
                    details[@"work_begin_at"] = cell.dataTextField.text;
                    break;
                case RE_WORK_END_AT:
                    details[@"work_end_at"] = cell.dataTextField.text;
                    break;
                case RE_WAGE:
                    details[@"wage"] = cell.dataTextField.text;
                    break;
                case RE_PERSONS:
                    details[@"persons"] = cell.dataTextField.text;
                    break;
                case RE_DEADLINE:
                    details[@"deadline"] = cell.dataTextField.text;
                    break;
                case RE_CONTACT_NAME:
                    details[@"contact_name"] = cell.dataTextField.text;
                    break;
                case RE_CONTACT_PHONE:
                    details[@"contact_phone"] = cell.dataTextField.text;
                    break;
                case RE_CONTACT_EMAIL:
                    details[@"contact_email"] = cell.dataTextField.text;
                    break;
            }
        }
    }
    
    details[@"case_status"] = @"Open";
    [details saveInBackground];
}


- (IBAction)finishEditBtnPressed:(id)sender {
    
    NSLog(@"the finishEditBtnPressed pressed\n");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"完成編輯" message:@"你是否已完成編輯工作內容？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //[self saveCaseDetailsToRemoteServer];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    }];

    [alert addAction:cancel];
    [alert addAction:ok];

    [self presentViewController:alert animated:true completion:nil];
        
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


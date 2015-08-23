//
//  SettingTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/5.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "SettingTableViewController.h"
#import "TakePictureView.h"
#import <Parse/Parse.h>
#import <Parse/PFQuery.h>

@interface SettingTableViewController ()<UITextFieldDelegate, TakePictureViewDelegate>
{
    NSMutableArray *settingDetailList;
    NSMutableDictionary *settingDetailData;
    TakePictureView  *avatarHeader;
    BOOL isEditing;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *theEditBtn;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    settingDetailList = [[NSMutableArray alloc] initWithObjects:
                         @"姓名", @"暱稱", @"性別", @"生日",@"手機", @"電子信箱",nil];
    
    avatarHeader = [[[NSBundle mainBundle] loadNibNamed:@"TakePictureView" owner:nil options:nil] lastObject];
    avatarHeader.thePictureLabel.text = @"設定自己的大頭貼";
    avatarHeader.takePicturedViewDlegate = self;
    
    isEditing = false;

    if ([PFUser currentUser] == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未登入" message:@"請先登入你的帳號" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController *vc ;
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
            [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }else{
        [self initUserData];
    }
}

- (void) initUserData
{
    PFUser *user = [PFUser currentUser];
    if (user == nil) {
        NSLog(@"Error! Setting menu init, user does not login!");
        return;
    }
    if (settingDetailData == nil) {
        settingDetailData = [NSMutableDictionary new];
    }
    
    [settingDetailData setObject:(NSString*)user[@"username"] forKey:@(RE_USERNAME)];
    [settingDetailData setObject:(NSString*)user[@"nickname"] forKey:@(RE_USER_NICKNAME)];
    [settingDetailData setObject:(NSString*)user[@"gender"] forKey:@(RE_USER_GENDER)];
    [settingDetailData setObject:(NSString*)user[@"birthday"] forKey:@(RE_USER_BIRTHDAY)];
    [settingDetailData setObject:(NSString*)user[@"phone"]forKey:@(RE_USER_PHONE)];
    [settingDetailData setObject:(NSString*)user[@"email"] forKey:@(RE_USER_EMAIL)];

    NSLog(@"%@", settingDetailData);
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

    return avatarHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return settingDetailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    //    cell.dataTextField.delegate = self;
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"SettingCells" owner:nil options:nil];
    cell = (SettingTableViewCell *)[view lastObject];
    cell.titleLabel.text = settingDetailList[indexPath.row];
    
    switch (indexPath.row) {
        case RE_USERNAME:
            cell.dataLabel.text = [settingDetailData objectForKey:@(RE_USERNAME)];
            cell.dataTextField.text = [settingDetailData objectForKey:@(RE_USERNAME)];
            break;
        case RE_USER_NICKNAME:
            cell.dataLabel.text = [settingDetailData objectForKey:@(RE_USER_NICKNAME)];
            cell.dataTextField.text = [settingDetailData objectForKey:@(RE_USER_NICKNAME)];
            break;
        case RE_USER_GENDER:
            cell.dataLabel.text = [settingDetailData objectForKey:@(RE_USER_GENDER)];
            cell.dataTextField.text = [settingDetailData objectForKey:@(RE_USER_GENDER)];
            break;
        case RE_USER_BIRTHDAY:
            cell.dataLabel.text = [settingDetailData objectForKey:@(RE_USER_BIRTHDAY)];
            cell.dataTextField.text = [settingDetailData objectForKey:@(RE_USER_BIRTHDAY)];
            break;
        case RE_USER_PHONE:
            cell.dataLabel.text = [settingDetailData objectForKey:@(RE_USER_PHONE)];
            cell.dataTextField.text = [settingDetailData objectForKey:@(RE_USER_PHONE)];
            break;
        case RE_USER_EMAIL:
            cell.dataLabel.text = [settingDetailData objectForKey:@(RE_USER_EMAIL)];
            cell.dataTextField.text = [settingDetailData objectForKey:@(RE_USER_EMAIL)];
            break;
            
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditing == false) {
        return;
    }
    
    NSArray *cellArray = [tableView visibleCells];
    
    SettingTableViewCell *cell = cellArray[indexPath.row];
    
    if (indexPath.row == RE_USER_GENDER) {
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    if (isEditing == false) {
        return;
    }
    NSArray *cellArray = [tableView visibleCells];
    SettingTableViewCell *cell = cellArray[indexPath.row];
    if([cell.dataLabel.text length] > 0)
    {
        [settingDetailData setObject:cell.dataLabel.text forKey:@(indexPath.row)];
    }
    
    cell.dataLabel.hidden = NO;
    cell.dataTextField.hidden = YES;
}


- (void)changePictureView
{
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

#pragma mark - image picker controller

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取得使用者拍攝照片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //存檔
    //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    
    avatarHeader.thePictureBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [avatarHeader.thePictureBtn setImage:image forState:UIControlStateNormal];
    
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
    popover.sourceView = avatarHeader;
    // handle the popover arrow
    popover.sourceRect = avatarHeader.bounds;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) saveUserDataToRemoteServer{
    
    PFUser *user = [PFUser currentUser];
    NSArray * allkeys = [settingDetailData allKeys];
    for (NSNumber *key in allkeys) {
        NSString *data = [settingDetailData objectForKey:key];
        NSLog(@"Key:%d value:%@",key.intValue, data);
        

        switch (key.intValue) {
            case RE_USERNAME:
                user[@"username"] = [settingDetailData objectForKey:@(RE_USERNAME)];
                break;
            case RE_USER_NICKNAME:
                user[@"nickname"] = [settingDetailData objectForKey:@(RE_USER_NICKNAME)];
                break;
            case RE_USER_GENDER:
                user[@"gender"] = [settingDetailData objectForKey:@(RE_USER_GENDER)];
                break;
            case RE_USER_BIRTHDAY:
                user[@"birthday"] = [settingDetailData objectForKey:@(RE_USER_BIRTHDAY)];
                break;
            case RE_USER_PHONE:
                user[@"phone"] = [settingDetailData objectForKey:@(RE_USER_PHONE)];
                break;
            case RE_USER_EMAIL:
                user[@"email"] = [settingDetailData objectForKey:@(RE_USER_EMAIL)];
                break;
                
        }
    }
    
    [user saveInBackground];
}

- (IBAction)editBtnPressed:(id)sender {
    NSLog(@"Setting menu edit btn pressed");
    if ([self.theEditBtn.title isEqualToString:@"編輯"]) {
        
        [SlideNavigationController sharedInstance].leftBarButtonItem.enabled = false;
        self.theEditBtn.title= @"完成";
        isEditing = true;
    }else
    {
        if (self.tableView.indexPathForSelectedRow != nil)
        {
            NSLog(@"I am comming in done btn");
            NSArray *cellArray = [self.tableView visibleCells];
            SettingTableViewCell *cell = cellArray[self.tableView.indexPathForSelectedRow.row];
            [cell.dataTextField resignFirstResponder];
            cell.dataLabel.text = cell.dataTextField.text;
            cell.dataLabel.hidden = NO;
            cell.dataTextField.hidden = YES;
            if([cell.dataTextField.text length] > 0)
            {
                [settingDetailData setObject:cell.dataLabel.text forKey:@(self.tableView.indexPathForSelectedRow.row)];
            }
        }
        //[self saveUserDataToRemoteServer];
        self.theEditBtn.title= @"編輯";
        isEditing = false;
        [SlideNavigationController sharedInstance].leftBarButtonItem.enabled = true;
    }
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

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
    NSMutableArray *imagearrayList;
    NSMutableDictionary *settingDetailData;
    UIDatePicker *datepicker;
    TakePictureView  *avatarHeader;
    BOOL isEditing;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *theEditBtn;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    settingDetailList = [[NSMutableArray alloc] initWithObjects:
                         @"姓名:",
                         @"暱稱:",
                         @"性別:",
                         @"生日:",
                         @"手機:",
                         @"信箱:",nil];
    imagearrayList = [[NSMutableArray alloc] initWithObjects:
                      @"vcard_color_64x64.png",
                        @"aim_color_64x64.png",
                        @"flickr_color_64x64",
                        @"ffffound_color_64x64.png",
                        @"tumbrl_color_64x64.png",
                      @"wiki_color_64x64.png",
                  nil];
    
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
    
    //Date Picker init
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datepicker.minuteInterval = 5;
    datepicker.backgroundColor = [UIColor whiteColor];
    
//    if (self.startEditFromRegister) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"註冊訊息" message:@"請填入基本資料" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self editBtnPressed:nil];
//        }];
//        
//        [alert addAction:ok];
//        [self presentViewController:alert animated:true completion:nil];
//    }
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
    
    [self getUserAvatarFromRemoteServer];

    NSLog(@"%@", settingDetailData);
}

- (void) getUserAvatarFromRemoteServer
{
    PFUser *user = [PFUser currentUser];
    PFFile *userImageFile = user[@"avatar"];
    if (userImageFile != nil) {
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                if (imageData) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    avatarHeader.thePictureBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [avatarHeader.thePictureBtn setImage:image forState:UIControlStateNormal];
                }
                
            }else
            {
                NSLog(@"%@", error.description);
            }
        }];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if (self.startEditFromRegister) {
        return  NO;
    }else
    {
        return YES;
    }
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
    cell.iconTitle.image = [UIImage imageNamed:imagearrayList[indexPath.row]];
    //cell.iconTitle.image = [UIImage imageNamed:imagearray[indexPath.row]];
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
    cell.titleLabel.hidden = NO;
    cell.iconTitle.hidden = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditing == false) {
        return;
    }
    
    SettingTableViewCell *cell = (SettingTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == RE_USER_GENDER ) {
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
    if (indexPath.row == RE_USER_BIRTHDAY){
        
        datepicker.datePickerMode = UIDatePickerModeDate;
        
//    else
//        {
//            datepicker.datePickerMode = UIDatePickerModeDateAndTime;
//        }
    
        [cell.dataTextField setInputView:datepicker];
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor colorWithRed: 1.0 green: 0.5781 blue: 0.0 alpha: 1.0]];
        [toolBar setTranslucent:YES];
        [toolBar setBackgroundColor:[UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishDataUpdate)];
        
        
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [cell.dataTextField setInputAccessoryView:toolBar];
    
    
    
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
    
    if([cell.dataTextField.text length] > 0){
        cell.dataLabel.text = cell.dataTextField.text;
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
    
    //save to parse file
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);

    PFFile *imageFile = [PFFile fileWithName:@"userAvatar.jpg" data:imageData];
    
    PFUser *user = [PFUser currentUser];
    user[@"avatar"] = imageFile;
    [user saveInBackground];
    
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
//        self.theEditBtn.image = [UIImage imageNamed:@"FinishButton.png"];
        self.theEditBtn.title= @"完成";
        isEditing = true;
        [self isEnableLeftBarButtonItem:false];
    }else
    {
        if (self.startEditFromRegister) {
            [self finishRegisterEdit];
            return;
        }
        
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
        [self saveUserDataToRemoteServer];
        self.theEditBtn.image = [UIImage imageNamed:@"EditButton.png"];
        self.theEditBtn.title= @"編輯";
        isEditing = false;
        [self isEnableLeftBarButtonItem:true];
    }
}

- (void) finishRegisterEdit
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"註冊完成" message:@"請確認完成基本資料填寫" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (self.tableView.indexPathForSelectedRow != nil)
        {
            NSLog(@"I will finish edit");
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
        [self saveUserDataToRemoteServer];
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"MapViewController"];
        
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:true completion:nil];
}

- (void) isEnableLeftBarButtonItem:(BOOL)flag
{
    self.navigationItem.leftBarButtonItem.enabled = flag;
}

- (void) finishDataUpdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *cellArray = [self.tableView visibleCells];
    SettingTableViewCell *cell = cellArray[self.tableView.indexPathForSelectedRow.row];
    cell.dataTextField.text = [formatter stringFromDate:datepicker.date];
    [cell.dataTextField resignFirstResponder];
    NSLog(@"生日為：%@", [formatter stringFromDate:datepicker.date]);
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

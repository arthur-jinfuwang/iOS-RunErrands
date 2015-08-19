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
    TakePictureView  *avatarHeader;
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
                         @"姓名", @"暱稱", @"性別", @"生日",@"手機", @"電子信箱",nil];
    avatarHeader = [[[NSBundle mainBundle] loadNibNamed:@"TakePictureView" owner:nil options:nil] lastObject];
    avatarHeader.thePictureLabel.text = @"設定自己的大頭貼";
    avatarHeader.takePicturedViewDlegate = self;

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
    PFQuery *query =  [PFUser query];
    if (query) {
        [query getObjectInBackgroundWithId:[[PFUser currentUser]objectId] block:^(PFObject *object, NSError *error){
            
            switch (indexPath.row) {
                case 0:
                    NSLog(@"%@", [object objectForKey:@"username"]);
                    cell.dataLabel.text = [object objectForKey:@"username"];
                    break;
                case 1:
                    NSLog(@"%@", [object objectForKey:@"nick_name"]);
                    cell.dataLabel.text = [object objectForKey:@"nick_name"];
                    break;
                case 2:
                    NSLog(@"%@", [object objectForKey:@"gender"]);
                    cell.dataLabel.text = [object objectForKey:@"gender"];
                    break;
                case 3:
                    NSLog(@"%@", [object objectForKey:@"birthday"]);
                    cell.dataLabel.text = [object objectForKey:@"birthday"];
                    break;
                case 4:
                    NSLog(@"%@", [object objectForKey:@"phone"]);
                    cell.dataLabel.text = [object objectForKey:@"phone"];
                    break;
                case 5:
                    NSLog(@"%@", [object objectForKey:@"email"]);
                    cell.dataLabel.text = [object objectForKey:@"email"];
                    break;
                default:
                    break;
            }
        }];
    }
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    NSArray *cellArray = [tableView visibleCells];
    SettingTableViewCell *cell = cellArray[indexPath.row];
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

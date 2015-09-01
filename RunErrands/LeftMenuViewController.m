//
//  LeftMenuViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/22.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import <Parse/Parse.h>


@interface LeftMenuViewController ()
{
    NSArray *viewArray;
    NSArray *viewControllerArroy;
    USERLOGINSTATUS loginStatus;
}

@end

@implementation LeftMenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.separatorColor = [UIColor clearColor];
    viewArray = [NSArray arrayWithObjects:
                 @"👍🏿 接案",
                 @"💳 發案",
                 @"🌟 追蹤",
                 @"👥 甄選",
                 @"🔧 設定",
                 @"☑️ 登入",
                   nil];
    
    viewControllerArroy = [NSArray arrayWithObjects:
                           @"MapViewController",
                           @"PostListTableViewController",
                           @"FollowTableViewController",
                           @"MessageTableViewController",
                           @"SettingTableViewController",
                           @"LoginViewController",nil];
    
    
    //讀取標題的區域
    
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil] lastObject];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return viewArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];

    if (indexPath.row == LOGINMENU) {
        if (loginStatus == USERLOGIN)
        
        {
            cell.textLabel.text = @"☑️ 登出";
        }else
        {
            cell.textLabel.text = @"☑️ 登入";
        }
    }else{
        cell.textLabel.text = viewArray[indexPath.row];
    }

    cell.backgroundColor = [UIColor clearColor];
    
    [cell setTextColor:[UIColor colorWithRed:255/255.0f green:78/255.0f blue:0/255.0f alpha:1]];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIViewController *vc ;
    FUMCTIONMENUS menu = indexPath.row;
    
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: viewControllerArroy[menu]];
/*
    if (indexPath.row == LOGINMENU) {
        if (loginStatus == USERLOGIN) {
           [self setLoginStatus:USERLOGOUT];
            // logout function
            NSLog(@"user logout finish");
            return;
        }
    }
*/
    
/*
    switch (indexPath.row)
    {
        case 0:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
            break;
            
        case 1:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
            break;
            
        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FriendsViewController"];
            break;
            
        case 3:
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            return;
            break;
    }
  */
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:self.slideOutAnimationEnabled andCompletion:nil];

}

// Arthur warning visibleCells
- (void) setLoginStatus:(USERLOGINSTATUS)status{
    
    NSArray *cellArray = [_tableView visibleCells];
    
    if (cellArray == nil) {
        NSLog(@"cellArray is nil");
    }else
    {
        UITableViewCell *cell = cellArray[LOGINMENU];
        if (status == USERLOGIN)
        
        {
            cell.textLabel.text = @"☑️ 登出";
        }
        else
        {
            cell.textLabel.text = @"☑️ 登入";
        }
        NSLog(@"cellArray is ok");
    }
    
    loginStatus = status;
    
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

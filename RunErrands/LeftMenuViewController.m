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

@interface LeftMenuViewController ()
{
    NSArray *viewArray;
    NSArray *viewControllerArroy;
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
                 @"接案",
                 @"發案",
                 @"追蹤",
                 @"訊息",
                 @"設定",
                 @"登入",nil];
    viewControllerArroy = [NSArray arrayWithObjects:
                           @"MapViewController",
                           @"PostCastViewController",
                           @"FollowTableViewController",
                           @"MessageTableViewController",
                           @"SettingViewController",
                           @"LoginViewController",nil];
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    
    cell.textLabel.text = viewArray[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *vc ;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: viewControllerArroy[indexPath.row]];
    

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

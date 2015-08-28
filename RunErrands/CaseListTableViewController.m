//
//  CaseListTableViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/23.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "CaseListTableViewController.h"
#import "CaseListCell.h"
#import <Parse/Parse.h>
#import "CaseDetailsTableViewController.h"

@interface CaseListTableViewController ()

@end

@implementation CaseListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.caselist != nil) {
        for ( PFObject *object in self.caselist ) {
            NSLog(@"Case list %@", object.objectId);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

//- (IBAction)backToMapBtnPressed:(UIStoryboardSegue *)segue
//{
//    NSLog(@"back to map!!");
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _caselist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"caseCell"];
    //cell.textLabel.text = [NSString stringWithFormat:@"case %ld", (long)indexPath.row];
    
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"CaseListCell" owner:nil options:nil];
    cell = (CaseListCell *)[view lastObject];
    
    PFObject *object = self.caselist[indexPath.row];
    
    cell.theCityLabel.text = object[@"work_city"];
    cell.theFollowLabel.hidden = YES;

    cell.thePostTimeLabel.text =object[@""];
    cell.theTitleLabel.text = object[@"case_title"];
    NSString *wage = [NSString stringWithFormat:@"%@: %@", object[@"wage_class"], object[@"wage"]];
    cell.theWageLabel.text = wage;
    cell.theUserIDLabel.text = object[@"contact_name"];
    //download
    PFFile *imageFile = object[@"case_photo"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [cell.theImageView setImage:image];
        }else
        {
            NSLog(@"%@", error.description);
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString* viewType = @"CaseDetailsTableViewController";
    CaseDetailsTableViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:viewType];
    
    PFObject * object = self.caselist[indexPath.row];
    viewController.caseObject = object;
    [viewController setIsEnableFollow:YES];
    
    [self.navigationController pushViewController:viewController animated:YES];
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

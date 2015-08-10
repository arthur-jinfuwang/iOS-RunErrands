//
//  ResumeViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/27.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "ResumeViewController.h"

@interface ResumeViewController ()
{
    NSMutableArray *imagearray;
    
}

@end

@implementation ResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    [imagearray addObject:[UIImage imageNamed:@"screen@2x(1).png"]];
    [imagearray addObject:[UIImage imageNamed:@"screen@2x(2).png"]];
    [imagearray addObject:[UIImage imageNamed:@"screen@2x(3).png"]];
    [imagearray addObject:[UIImage imageNamed:@"screen@2x(4).png"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resumeCell"];
    //    cell.dataTextField.delegate = self;
    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"SettingCells" owner:nil options:nil];
    cell = (SettingTableViewCell *)[view lastObject];
    
    cell.titleLabel.text = [[NSString alloc] initWithFormat:@"resume cell %ld", indexPath.row];
    cell.iconTitle.animationImages = imagearray;
    cell.titleLabel.hidden = YES;
    cell.iconTitle.hidden = NO;
    
    return cell;
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

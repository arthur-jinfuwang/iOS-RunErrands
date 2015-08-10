//
//  MessageListCellTableView.m
//  RunErrands
//
//  Created by Tony on 8/3/15.
//  Copyright (c) 2015 Jinfu Wang. All rights reserved.
//

#import "MessageListCellTableView.h"

@implementation MessageListCellTableView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
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
    return 5;
}
//生成另外頁面的物件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCellTableView *cell = [tableView dequeueReusableCellWithIdentifier:@"ResumeCell"];
    
    // Configure the cell...
//    cell.textLabel.text = [NSString stringWithFormat:@"message %ld", (long)indexPath.row];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"case %ld", (long)indexPath.row];
    
//    NSArray *view = [[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:nil options:nil];
//    cell = (MessageListCellTableView *)[view lastObject];
    
    return cell;
}


//點擊會去讀取下一個頁面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString* viewType = @"ResumeViewController";
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:viewType];
    
    
}









@end

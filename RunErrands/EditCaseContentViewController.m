//
//  EditCaseContentViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/8/22.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "EditCaseContentViewController.h"

@interface EditCaseContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *theEditCaseTextView;

@end

@implementation EditCaseContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _theEditCaseTextView.delegate = self;
    _theEditCaseTextView.text =_textContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelEditBtnPressed:(id)sender {
    NSLog(@"the cancelEditCaseBtnPressed pressed\n");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消編輯" message:@"你是否想要取消編輯內容？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //跳轉到下個頁面

        NSArray * array = self.navigationController.viewControllers;
        NSUInteger index = [array indexOfObject:self];
        id viewcontroller = [array objectAtIndex:index-1];
        [self.navigationController popToViewController:viewcontroller animated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)finishEditBtnPressed:(id)sender {
    NSLog(@"the finishEditBtnPressed pressed\n");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"完成編輯" message:@"你是否已完成編輯工作內容？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.editedTextContent(_theEditCaseTextView.text);
        
        NSArray * array = self.navigationController.viewControllers;
        NSUInteger index = [array indexOfObject:self];
        id viewcontroller = [array objectAtIndex:index-1];
        [self.navigationController popToViewController:viewcontroller animated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    NSLog(@"textViewShouldEndEditing:");
    
    return YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSLog(@"textViewDidEndEditing:");
}

- (void)setTheEditedContent:(NSString *)content
{
    _textContent = nil;
    _textContent = content;
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

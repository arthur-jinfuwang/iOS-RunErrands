//
//  LoginViewController.m
//  RunErrands
//
//  Created by Jinfu Wang on 2015/7/25.
//  Copyright (c) 2015年 Jinfu Wang. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LeftMenuViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface LoginViewController (){
    LeftMenuViewController *leftMenu;
}
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtnpressed;
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *ParseLoginMethod;


@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];

    leftMenu =(LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        PFUser *currentUser = [PFUser currentUser]; // this will now be nil
        [leftMenu setLoginStatus:USERLOGIN];
        [_ParseLoginMethod setTitle:@"登出"  forState:UIControlStateNormal];
        [_RegisterBtnpressed setTitle:@"註冊" forState:UIControlStateNormal];
    } else {
        // this will now be nil
        PFUser *currentUser = [PFUser currentUser];
        [_ParseLoginMethod setTitle:@"登入"forState:UIControlStateNormal];
        [_RegisterBtnpressed setTitle:@"註冊" forState:UIControlStateNormal];
        
    }

    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"facebook 已登入");
        [_facebookLoginBtn setTitle:@"登出 facebook" forState:UIControlStateNormal];
        
    }else{
        NSLog(@"facebook 未登入");
        [_facebookLoginBtn setTitle:@"登入 facebook" forState:UIControlStateNormal];
        leftMenu =(LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu;
        leftMenu.headerView.displayFacebookName.text = @"";
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


#pragma mark parse Login and Register

- (IBAction)RegisterBtnpressed:(id)sender
{
            //建立輸入帳號資料訊息框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"註冊" message:@"請輸入帳號密碼" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *uid = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
        NSString *pwd = ((UITextField *)[alertController.textFields objectAtIndex:1]).text;
        NSString *repwd = ((UITextField *)[alertController.textFields objectAtIndex:2]).text;
        
        PFUser *user = [PFUser user];
        user.username = uid;
        user.password = pwd;
        [user setObject:uid forKey:@"email"];
        [user setObject:@""forKey:@"gender"];
        [user setObject:@""forKey:@"birthday"];
        [user setObject:@"" forKey:@"nickname"];
        [user setObject:@"" forKey:@"phone"];
        //[user saveInBackground];
        
        
        //註冊成功後
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"註冊訊息" message:@"登入成功" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"SettingTableViewController"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
                        [_ParseLoginMethod setTitle:@"登出"  forState:UIControlStateNormal];
                        [leftMenu setLoginStatus:USERLOGOUT];
                    });
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:true completion:nil];
            } else {
                if(pwd != repwd)
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"註冊訊息" message:@"密碼不符,請重新輸入" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    
                    [alert addAction:ok];
                    [self presentViewController:alert animated:true completion:nil];

                }
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"註冊訊息" message:@"資料不符,請重新輸入" preferredStyle:UIAlertControllerStyleAlert];
                
                            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                            }];
                
                            [alert addAction:ok];
                            [self presentViewController:alert animated:true completion:nil];

                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"error:%@",[error userInfo]);
              
            }
        }];

        
        NSLog(@"帳號:%@",uid);
        NSLog(@"密碼:%@",pwd);
        NSLog(@"再次確認:%@",repwd);
        
        
            }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"電子信箱";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密碼";
        textField.secureTextEntry = YES;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"再次確認密碼";
        textField.secureTextEntry = YES;
            }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (IBAction)LoginBtnpressed:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        [self userLogOut];
        [_ParseLoginMethod setTitle:@"登入" forState:UIControlStateNormal];
    }else{
       [PFUser logInWithUsernameInBackground:_accountTextfield.text password:_passwordTextfield.text
    block:^(PFUser *user, NSError *error) {
    if (user) {
                                            // Do stuff after successful login.
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"註冊訊息" message:@"登入成功" preferredStyle:UIAlertControllerStyleAlert];
                                            
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"MapViewController"];
                dispatch_async(dispatch_get_main_queue(), ^{
                [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
                                                });
                                            }];
                [alert addAction:ok];
                [self presentViewController:alert animated:true completion:nil];
                [_ParseLoginMethod setTitle:@"登出"  forState:UIControlStateNormal];
                }
                else
                {
                                            // The login failed. Check error to see why.
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登入訊息" message:@"登入失敗,請重新輸入" preferredStyle:UIAlertControllerStyleAlert];
                                            
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                
                                            }];
                                            
                [alert addAction:ok];
                [self presentViewController:alert animated:true completion:nil];
                                            
                                        }
                                    }];
                [leftMenu setLoginStatus:USERLOGIN];
    
    }
}

- (void)parseuserLogOut  {
    [PFUser logOut];
    [leftMenu setLoginStatus:USERLOGOUT];
}


#pragma mark Login Facebook

-(void)loginWithFacebook {
    // Login PFUser using Facebook
    // Set permissions required from the facebook user account
    //NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    NSArray *permissionsArray = @[@"public_profile", @"email"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self loadFacebookData:user];
            [leftMenu setLoginStatus:USERLOGIN];
            [_facebookLoginBtn setTitle:@"登出 facebook" forState:UIControlStateNormal];
        } else {
            NSLog(@"User logged in through Facebook!");
            [leftMenu setLoginStatus:USERLOGIN];
            [_facebookLoginBtn setTitle:@"登出 facebook" forState:UIControlStateNormal];
        }
    }];
}

- (void)loadFacebookData:(PFUser *)user {
    
    if (![FBSDKAccessToken currentAccessToken])
        return;
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id,about,email,name,gender,locale,age_range,location,link,birthday,picture.type(large)"}];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            NSString *email = userData[@"email"];
            NSString *age_range = userData[@"age_range"];
            NSString *about = userData[@"about"];
            NSLog(@"%@\n, %@\n, %@\n, %@\n, %@\n, %@\n, %@\n, %@\n, %@\n", facebookID, name, email,location, gender, birthday, relationship, age_range, about);
            
            [user setObject:facebookID forKey:@"facebookID"];
            [user setObject:[name length] ? name : @"" forKey:@"username"];
            [user setObject:[email length] ? email : @"" forKey:@"email"];
            [user setObject:[gender isEqualToString:@"male"] ? @"男性" : @"女性" forKey:@"gender"];
            [user setObject:[birthday length] ? birthday: @"" forKey:@"birthday"];
            [user setObject:[name length] ? name : @"" forKey:@"nickname"];
            [user setObject:@"" forKey:@"phone"];
            [user saveInBackground];
            
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Now add the data to the UI elements
            // ...
        }
    }];
}

- (void)userLogOut  {
    [PFUser logOut];
    [leftMenu setLoginStatus:USERLOGOUT];
}

- (IBAction)facebookLoginBtnPressed:(id)sender {
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        [self userLogOut];
        [_facebookLoginBtn setTitle:@"登入 facebook" forState:UIControlStateNormal];
    }else{

        [self loginWithFacebook];
    }
    
}


// - (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

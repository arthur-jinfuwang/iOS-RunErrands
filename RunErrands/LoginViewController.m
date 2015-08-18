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

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];

    leftMenu =(LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu;
    
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
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
            [self loadFacebookData:user];
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
            [user setObject:[name length] ? name : [NSNull null] forKey:@"username"];
            [user setObject:[email length] ? email : [NSNull null] forKey:@"email"];
            [user setObject:[gender length] ? gender : [NSNull null] forKey:@"gender"];
            [user setObject:[birthday length] ? birthday: [NSNull null] forKey:@"birthday"];
            [user saveInBackground];
            
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Now add the data to the UI elements
            // ...
        }
    }];
}

- (void)userLogOut  {
    [PFUser logOut];
}

- (IBAction)facebookLoginBtnPressed:(id)sender {
    
    if ([FBSDKAccessToken currentAccessToken]){
        [self userLogOut];
        [_facebookLoginBtn setTitle:@"登入 facebook" forState:UIControlStateNormal];
    }else{

        [self loginWithFacebook];
        [_facebookLoginBtn setTitle:@"登出 facebook" forState:UIControlStateNormal];
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

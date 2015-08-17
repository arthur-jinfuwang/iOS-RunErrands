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
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    [FBSDKLoginButton class];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];

    leftMenu =(LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"已登入");
        
    }else{
        NSLog(@"未登入");
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
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
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
            [user setObject:name forKey:@"username"];
            [user setObject:email forKey:@"email"];
            [user setObject:gender forKey:@"gender"];
            [user setObject:birthday forKey:@"birthday"];
            [user saveInBackground];
            
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Now add the data to the UI elements
            // ...
        }
    }];
}

- (void)UserLogOut  {
    [PFUser logOut];
}

- (IBAction)facebookLoginBtnPressed:(id)sender {
    
    [self loginWithFacebook];
}



- (IBAction)FaceookLoginBtn:(id)sender {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    leftMenu =(LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
        
        NSLog(@"已登入");
        [leftMenu setLoginStatus:USERLOGOUT];
        
        //轉至其它畫面...        //Change the slider menu text from login to logout
    }else{
        
        //未登入
        
        [loginManager logInWithReadPermissions:@[@"public_profile",@"email",@"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            NSLog(@"%@",[[[result grantedPermissions]allObjects]description]);
            if (error) {
                // Process error
                NSLog(@"FB login error! %@\n",error.description);
            } else if (result.isCancelled) {
                // Handle cancellations
                NSLog(@"FB canceled\n");
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"email"]) {
                    // Do work
                    NSLog(@"email is ok");
                }
                if ([result.grantedPermissions containsObject:@"public_profile"]) {
                    // Do work
                    NSLog(@"public_profile is ok");
                }
                if ([result.grantedPermissions containsObject:@"user_friends"]) {
                    // Do work
                    NSLog(@"user_friends is ok");
                }
            }

            /*
            NSLog(@"%@",[[[result grantedPermissions]allObjects]description]);
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,name,gender,locale"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *results, NSError *error) {
                 NSLog(@"%@",results);
                 NSLog(@"%@",[results objectForKey:@"email"]);
                 NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/mydata.txt"];
                 leftMenu.headerView.displayFacebookName.text = [results objectForKey:@"name"];
                 
             }];
            */
            
        }];
        
        //Change the slider menu text from login to logout
        [leftMenu setLoginStatus:USERLOGIN];
        
        //Turn to map view menu
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController *lc ;
        
        lc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MapViewController"];
        [[SlideNavigationController sharedInstance] switchToViewController:lc withCompletion:nil ];
        
        
        NSLog(@"not");
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

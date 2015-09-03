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
#import "SettingTableViewController.h"


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
@synthesize networkBroken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];

    leftMenu =(LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu;
    
    if (networkBroken) {
        self.facebookLoginBtn.enabled = false;
        self.RegisterBtnpressed.enabled =false;
        self.ParseLoginMethod.enabled= false;
    }
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [leftMenu setLoginStatus:USERLOGIN];
        [_ParseLoginMethod setTitle:@"登出"  forState:UIControlStateNormal];
        [_RegisterBtnpressed setTitle:@"註冊" forState:UIControlStateNormal];
    } else {
        [_ParseLoginMethod setTitle:@"登入"forState:UIControlStateNormal];
        [_RegisterBtnpressed setTitle:@"註冊" forState:UIControlStateNormal];
        
    }

    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"facebook 已登入");
        [_facebookLoginBtn setTitle:@"facebook登出" forState:UIControlStateNormal];
        
    }else{
        NSLog(@"facebook 未登入");
        [_facebookLoginBtn setTitle:@"快速使用facebook登入" forState:UIControlStateNormal];
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
    if (self.networkBroken) {
        return NO;
    }else
    {
        return YES;
    }
}


#pragma mark parse Login and Register

- (IBAction)RegisterBtnpressed:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"跑腿幫 -(資訊及通訊傳播業)「個人資料保護法」公開聲明內容" message:@" 歡迎使用跑腿幫（以下稱本單位）相關服務，依據個人資料保護法（以下稱個資法）第八條第一項規定，為了確保使用者之個人資料、隱私及權益之保護，當您已閱讀並同意「跑腿幫單位個人資料保護法告知內容」時，即表示您願意以電子文件之方式行使法律所賦予同意之權利，並具有書面同意之效果，若不同意請離開此網頁，如需服務請洽本單位之服務人員。 (以下為本單位依「個人資料保護法」規定，必須向您告知的各項聲明，請您務必詳閱。)一、  個人資料蒐集目的：（一）從事資訊、通訊傳播、出版、影片服務、聲音錄製、音樂出版、傳播、節目播送、電信、電腦系統設計、資料處理及資訊供應服務等之行為均屬於本行業之個資蒐集目的。二）上述之相關業務或其他符合營業項目所定義之工作範圍。二、  個人資料蒐集類別：一）識別類（例如：中、英文姓名、國民身分證統一編號、識別碼、學生或員工證號、聯絡電話號碼、地址、性別、出生地、電子郵遞地址、帳戶號碼與戶名、其它識別證號或電子識別標章）、特徵類（例如：出生年月日、國籍、個人照片、筆跡與紙本文件）、社會情況類（例如：職業、學經歷）、財務細節類（例如：銀行帳號、戶名或與本蒐集目的相關之財務資訊）等。三、  個人資料利用之期間、地區、對象及方式：（一）期間：利用期間為本單位或業務所必須之保存期間。（二）地區：您的個人資料將用於本單位提供服務之地區。（三）對象：當您使用本服務時，本服務可能會公布或揭露給其他使用者依個人資料蒐集目的所蒐集、記錄或讀取之您的個人資料及其他資訊。四）方式：電子文件、紙本，或以自動化機器或其他非自動化之利用方式。四、  依據個資法第三條規定，您就本單位保有您的個人資料得行使下列權利：一）查詢、閱覽、複本、補充、更正、請求停止蒐集、請求停止處理、請求停止利用、請求刪除等權利。跑腿幫保有修訂本告知內容之權利，修正時亦同，以上條文參考自中華民國資料保護協會。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"註冊" message:@"請輸入帳號密碼" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        //建立輸入帳號資料訊息框
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
                        
                        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CopyrightViewController"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];
                            //[vc setStartEditFromRegister:true];
                            //                        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                            //                        [self presentViewController:nav animated:YES completion:nil];
                            [_ParseLoginMethod setTitle:@"登出"      forState:UIControlStateNormal];
                            [_RegisterBtnpressed setTitle:@"註冊"  forState:UIControlStateNormal];
                            [leftMenu setLoginStatus:USERLOGIN];
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

        //[self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
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
            [_facebookLoginBtn setTitle:@"facebook登出" forState:UIControlStateNormal];
        } else {
            NSLog(@"User logged in through Facebook!");
            [leftMenu setLoginStatus:USERLOGIN];
            [_facebookLoginBtn setTitle:@"facebook登出" forState:UIControlStateNormal];
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
        [_facebookLoginBtn setTitle:@"快速使用facebook登入" forState:UIControlStateNormal];
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

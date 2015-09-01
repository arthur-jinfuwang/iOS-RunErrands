//
//  openViewController.m
//  RunErrands
//
//  Created by Tony on 7/21/15.
//  Copyright (c) 2015 Jinfu Wang. All rights reserved.
//

#import "openViewController.h"
#import "MapViewController.h"
#import "SlideNavigationController.h"

@interface openViewController (){
    NSMutableArray *array;
}

@end

@implementation openViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];

    array = [[NSMutableArray alloc]init];
    [array addObject:[UIImage imageNamed:@"screen@2x(1).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(2).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(3).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(4).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(5).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(6).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(7).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(8).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(9).png"]];
    [array addObject:[UIImage imageNamed:@"screen@2x(10).png"]];
    self.openanimation.contentMode = UIViewContentModeScaleAspectFill;
    self.openanimation.animationImages = array;
    
    self.openanimation.animationDuration = 0.1;
    
    self.openanimation.animationRepeatCount = 1;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.openanimation startAnimating];
    [self performSelector:@selector(timernextstep) withObject:nil afterDelay:2];
    UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"跑腿幫 -(資訊及通訊傳播業)「個人資料保護法」公開聲明內容" message:@"歡迎使用跑腿幫（以下稱本單位）相關服務，依據個人資料保護法（以下稱個資法）第八條第一項規定，為了確保使用者之個人資料、隱私及權益之保護，當您已閱讀並同意「跑腿幫單位個人資料保護法告知內容」時，即表示您願意以電子文件之方式行使法律所賦予同意之權利，並具有書面同意之效果，若不同意請離開此網頁，如需服務請洽本單位之服務人員。 (以下為本單位依「個人資料保護法」規定，必須向您告知的各項聲明，請您務必詳閱。)一、  個人資料蒐集目的：（一）從事資訊、通訊傳播、出版、影片服務、聲音錄製、音樂出版、傳播、節目播送、電信、電腦系統設計、資料處理及資訊供應服務等之行為均屬於本行業之個資蒐集目的。（二）上述之相關業務或其他符合營業項目所定義之工作範圍。二、  個人資料蒐集類別：（一）識別類（例如：中、英文姓名、國民身分證統一編號、識別碼、學生或員工證號、聯絡電話號碼、地址、性別、出生地、電子郵遞地址、帳戶號碼與戶名、其它識別證號或電子識別標章）、特徵類（例如：出生年月日、國籍、個人照片、筆跡與紙本文件）、社會情況類（例如：職業、學經歷）、財務細節類（例如：銀行帳號、戶名或與本蒐集目的相關之財務資訊）等。三、  個人資料利用之期間、地區、對象及方式：(一）期間：利用期間為本單位或業務所必須之保存期間。（二）地區：您的個人資料將用於本單位提供服務之地區。（三）對象：本單位之共同行銷、交互運用客戶資料公司、合作推廣單位、業務往來機構、依法有調查權機關或金融監理機關。（四）方式：電子文件、紙本，或以自動化機器或其他非自動化之利用方式。四、  依據個資法第三條規定，您就本單位保有您的個人資料得行使下列權利：（一）查詢、閱覽、複本、補充、更正、請求停止蒐集、請求停止處理、請求停止利用、請求刪除等權利。跑腿幫保有修訂本告知內容之權利，修正時亦同，以上條文參考自中華民國資料保護協會。"
        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertContorller addAction:okAction];
    [self presentViewController:alertContorller animated:YES completion:nil];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.openanimation stopAnimating];
    self.openanimation.animationImages = nil;
    array = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) timernextstep{
    
    //跳轉到下個頁面
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIViewController *vc ;
    
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MapViewController"];
    
    
    [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc withCompletion:nil];

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

//
//  KKSignupViewController.m
//  KaKa
//
//  Created by yxj on 3/1/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKSignupViewController.h"
#import "NSString+MD5.h"
#import "AFNetworking.h"
#import <SVProgressHUD.h>
@interface KKSignupViewController ()

@property (nonatomic, strong) UITextField * userNameTextField;
@property (nonatomic, strong) UITextField * passwordTextField;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UIButton    * SignUpBtn;

@end

@implementation KKSignupViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"logBg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [self settingButtons];
}

- (void) backToLoginIn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) clickSignupNow {
    [self.view endEditing:YES];
    [self sendSignUpRequest];
    NSLog(@"%s", __func__);
}

- (void)sendSignUpRequest{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUsernameKey] = self.userNameTextField.text;
    params[kPasswordKey] = [self.passwordTextField.text MD5Digest];
    params[kMobileKey]   = self.phoneTextField.text;
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [session POST:kSignupServerAddress parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"errmsg"]  isEqual: @"service success"]) {
            /*
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject[@"ext_data"][kUsernameKey] forKey:kUsernameKey];
            [defaults synchronize]; */
            
            [self SignUpSuccess];
        } else {
            [SVProgressHUD showErrorWithStatus:@"wrong"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail, Error: %@", error);
    }];
}
- (void) SignUpSuccess {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"SignUpSuccess");
}
- (void) settingButtons {
//    UILabel *lblTitle = [[UILabel alloc]init];
//    lblTitle.size = CGSizeMake(150, 70);
//    lblTitle.center = CGPointMake(self.view.center.x +20, 70);
//    lblTitle.text = @"欢迎注册";
//    [self.view addSubview:lblTitle];
//
    
    //accout field
    UILabel *lblAccount = [[UILabel alloc]initWithFrame:CGRectMake(25, 180, 90, 40)];
    lblAccount.text = @"account:";
    
    [self.view addSubview:lblAccount];
    self.userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(110,185, 230, 40)];
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.alpha = 0.3;
    self.userNameTextField.layer.cornerRadius = 3;
    self.userNameTextField.layer.masksToBounds = YES;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.userNameTextField];
    //code1
    UILabel *lblCode1 = [[UILabel alloc]init];
    lblCode1.size = CGSizeMake(90, 40);
    lblCode1.center = CGPointMake(68, 260);
    lblCode1.text = @"code:";
    [self.view addSubview:lblCode1];
    
    self.passwordTextField = [[UITextField alloc]init];
    self.passwordTextField.size = CGSizeMake(230, 40);
    self.passwordTextField.center = CGPointMake(225, 260);
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.layer.cornerRadius =3 ;
    self.passwordTextField.alpha = 0.3;
    self.passwordTextField.layer.masksToBounds = YES;
    [self.view addSubview:self.passwordTextField];
    //code2,telePhone
    UILabel *lblTelePhone = [[UILabel alloc]init];
    lblTelePhone.size = CGSizeMake(90, 40);
    lblTelePhone.center = CGPointMake(68, 320);
    lblTelePhone.text = @"telephone:";
    [self.view addSubview:lblTelePhone];
    
    self.phoneTextField = [[UITextField alloc]init];
    self.phoneTextField.size = CGSizeMake(230, 40);
    self.phoneTextField.center = CGPointMake(225, 320);
    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.layer.cornerRadius = 3;
    self.phoneTextField.alpha = 0.3;
    self.phoneTextField.layer.masksToBounds = YES;
    [self.view addSubview:self.phoneTextField];
    
    
    // 注册验证 afnetworking :verifyAFN
    self.SignUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.SignUpBtn.size = CGSizeMake(150, 30);
    self.SignUpBtn.center = CGPointMake(self.view.center.x, 380);
    
    [self.SignUpBtn setTitle:@"确认注册" forState:UIControlStateNormal];
     [self.SignUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.SignUpBtn.backgroundColor = [UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1];
    self.SignUpBtn.layer.masksToBounds = YES;
    self.SignUpBtn.layer.cornerRadius = 3;
    [self.SignUpBtn addTarget:self action:@selector(clickSignupNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.SignUpBtn];
    
    
    //back
    UIButton *btnFinishSignUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnFinishSignUp.size = CGSizeMake(150, 30);
    btnFinishSignUp.center = CGPointMake(self.view.center.x, 430);
    btnFinishSignUp.backgroundColor = [UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1];
    btnFinishSignUp.layer.cornerRadius = 3;
    btnFinishSignUp.layer.masksToBounds = YES;
    [btnFinishSignUp setTitle:@"okLogin!" forState:UIControlStateNormal];
     [btnFinishSignUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btnFinishSignUp addTarget:self action:@selector(backToLoginIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFinishSignUp];
    
    [self.userNameTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
#warning testing
    self.userNameTextField.text = @"13125197322";
    self.passwordTextField.text = @"123456";
    self.phoneTextField.text    = @"13125197333";
}


- (void) textChange {
    self.SignUpBtn.enabled = self.userNameTextField.text.length && self.passwordTextField.text.length && self.phoneTextField.text.length;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end

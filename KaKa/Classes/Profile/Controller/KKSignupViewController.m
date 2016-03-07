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
            
            [SVProgressHUD showSuccessWithStatus:@"恭喜注册成功"];
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
#warning debuging
    NSLog(@"SignUpSuccess");
}
- (void) settingButtons {
    
    //accout field
    self.userNameTextField = [[UITextField alloc]init];
    self.userNameTextField.size = CGSizeMake(250, 30);
    self.userNameTextField.center = CGPointMake(self.view.center.x, 210);
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.alpha = 0.7;
    self.userNameTextField.layer.masksToBounds = YES;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.textColor = [UIColor colorWithRed:230/256.0 green:230/256.0 blue:230/256.0 alpha:1] ;
    [self.userNameTextField setPlaceholder:@"请输入帐号"];
    [self.userNameTextField setValue:[UIColor colorWithRed:190/256.0 green:190/256.0 blue:190/256.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    //设置光标颜色
    [self.userNameTextField setTintColor:[UIColor whiteColor]];
    //设置输入字体颜色
    [self.userNameTextField setTextColor:[UIColor whiteColor]];
    
    
    self.userNameTextField.layer.cornerRadius=8.0f;
    self.userNameTextField.layer.masksToBounds=YES;
    self.userNameTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.userNameTextField.layer.borderWidth= 1.0f;
    
    
    [self.view addSubview:self.userNameTextField];
    //code1
    self.passwordTextField = [[UITextField alloc]init];
    self.passwordTextField.size = CGSizeMake(250, 30);
    self.passwordTextField.center = CGPointMake(self.view.center.x, 260);
    self.passwordTextField.textColor = [UIColor colorWithRed:230/256.0 green:230/256.0 blue:230/256.0 alpha:1] ;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.alpha = 0.7;
    self.passwordTextField.layer.masksToBounds = YES;
  //  self.passwordTextField.placeholder = @"请输入密码";
    
    [self.passwordTextField setPlaceholder:@"请输入密码"];
    [self.passwordTextField setValue:[UIColor colorWithRed:190/256.0 green:190/256.0 blue:190/256.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    //设置光标颜色
    [self.passwordTextField setTintColor:[UIColor whiteColor]];
    //设置输入字体颜色
    [self.passwordTextField setTextColor:[UIColor whiteColor]];

    
    self.passwordTextField.layer.cornerRadius=8.0f;
    self.passwordTextField.layer.masksToBounds=YES;
    self.passwordTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.passwordTextField.layer.borderWidth= 1.0f;
    
    
    [self.view addSubview:self.passwordTextField];
    //code2,telePhone
    self.phoneTextField = [[UITextField alloc]init];
    self.phoneTextField.size = CGSizeMake(250, 30);
    self.phoneTextField.center = CGPointMake(self.view.center.x, 310);
    self.phoneTextField.textColor = [UIColor colorWithRed:230/256.0 green:230/256.0 blue:230/256.0 alpha:1] ;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
   // self.phoneTextField.layer.cornerRadius = 3;
    self.phoneTextField.alpha = 0.7;
    self.phoneTextField.layer.masksToBounds = YES;

    [self.phoneTextField setPlaceholder:@"请输入手机号"];
    [self.phoneTextField setValue:[UIColor colorWithRed:190/256.0 green:190/256.0 blue:190/256.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    //设置光标颜色
    [self.phoneTextField setTintColor:[UIColor whiteColor]];
    //设置输入字体颜色
    [self.phoneTextField setTextColor:[UIColor whiteColor]];
    

    
    self.phoneTextField.layer.cornerRadius=8.0f;
    self.phoneTextField.layer.masksToBounds=YES;
    self.phoneTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.phoneTextField.layer.borderWidth= 1.0f;
    
    [self.view addSubview:self.phoneTextField];
    
    // 注册验证 afnetworking :verifyAFN
    self.SignUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.SignUpBtn.size = CGSizeMake(250, 30);
    self.SignUpBtn.center = CGPointMake(self.view.center.x, 360);
    
    [self.SignUpBtn setTitle:@"确认注册" forState:UIControlStateNormal];
     [self.SignUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.SignUpBtn.backgroundColor = [UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1];
    self.SignUpBtn.layer.masksToBounds = YES;
    self.SignUpBtn.layer.cornerRadius = 3;
    [self.SignUpBtn addTarget:self action:@selector(clickSignupNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.SignUpBtn];
    
    
    //back
    UIButton *btnFinishSignUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnFinishSignUp.size = CGSizeMake(250, 30);
    btnFinishSignUp.center = CGPointMake(self.view.center.x, 410);
    btnFinishSignUp.layer.masksToBounds = YES;
    [btnFinishSignUp setTitle:@"现在登陆" forState:UIControlStateNormal];
     [btnFinishSignUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btnFinishSignUp setTitleColor:[UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1] forState:UIControlStateNormal];
    
    btnFinishSignUp.layer.cornerRadius=8.0f;
    btnFinishSignUp.layer.masksToBounds=YES;
    btnFinishSignUp.layer.borderColor= [[UIColor grayColor]CGColor];
    btnFinishSignUp.layer.borderWidth= 1.0f;
    
    
    
    
    [btnFinishSignUp addTarget:self action:@selector(backToLoginIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFinishSignUp];
    
    [self.userNameTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
//#warning testing
//    self.userNameTextField.text = @"13125197322";
//    self.passwordTextField.text = @"123456";
//    self.phoneTextField.text    = @"13125197333";
}


- (void) textChange {
    self.SignUpBtn.enabled = self.userNameTextField.text.length && self.passwordTextField.text.length && self.phoneTextField.text.length;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end

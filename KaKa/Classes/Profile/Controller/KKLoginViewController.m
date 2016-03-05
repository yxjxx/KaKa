//
//  KKLoginViewController.m
//  KaKa
//
//  Created by yxj on 3/1/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKLoginViewController.h"
#import "KKSignupViewController.h"
#import "KKMainPageViewController.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import <SVProgressHUD.h>

@interface KKLoginViewController()

@property (nonatomic, strong) UILabel *         mainTitleLabel;
@property (nonatomic, strong) UITextField *     userNameTextField;
@property (nonatomic, strong) UITextField *     passwordTextField;
@property (nonatomic, strong) UIButton *        loginButton;
@property (nonatomic, strong) UIButton *        registerButton;
@property (nonatomic, strong) UIImageView *backgroundLogin;

@end

@implementation KKLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"logBg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    self.navigationController.navigationBarHidden = YES;
   // [self.view addSubview:self.backgroundLogin];
    [self settingButtons];
}

- (void) textChange {
    self.loginButton.enabled = self.userNameTextField.text.length && self.passwordTextField.text.length ;
}
- (void)signupClicked {
    
    KKSignupViewController *signUpVc = [[KKSignupViewController alloc] init];
    
    [self.navigationController pushViewController:signUpVc animated:YES];
}

- (void)loginClicked {

    [self sendLoginRequest];
    
}

- (void)sendLoginRequest{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kMobileKey] = self.userNameTextField.text;
    params[kPasswordKey] = [self.passwordTextField.text MD5Digest];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [session POST:kLoginServerAddress parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"errmsg"]  isEqual: @"service success"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"isLog"];
            [defaults setObject:responseObject[@"ext_data"][kUsernameKey] forKey:kUsernameKey];
            [defaults synchronize];
            //[SVProgressHUD showInfoWithStatus:@"成功登陆"];.
            [SVProgressHUD showSuccessWithStatus:@"恭喜登陆成功"];
            //SVProgressHUD showImage:[UIImage imageNamed:@"logBg.jpg"] status:@"ok"
            [self loginSuccess];
        }  else {
            [SVProgressHUD showErrorWithStatus:@"密码或帖号错了"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail, Error: %@", error);
    }];
}

- (void)loginSuccess{
    
    [self.tabBarController setSelectedIndex:0];
}


- (void)viewWillDisappear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [defaults boolForKey:@"isLog"];
    if (isLogin) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void) settingButtons {
    
    //userName
    self.userNameTextField = [[UITextField alloc] init];
    self.userNameTextField.size = CGSizeMake(250, 35);
    self.userNameTextField.center = CGPointMake(self.view.center.x, 210);
    //self.userNameTextField.placeholder = @"请输入帐号";
    // self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.textColor = [UIColor colorWithRed:230/256.0 green:230/256.0 blue:230/256.0 alpha:1] ;
    // self.userNameTextField.layer.cornerRadius = 3;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.alpha = 0.7;
    
    [self.userNameTextField setPlaceholder:@"请输入帐号"];
    [self.userNameTextField setValue:[UIColor colorWithRed:190/256.0 green:190/256.0 blue:190/256.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    //设置光标颜色
    [self.userNameTextField setTintColor:[UIColor whiteColor]];
    //设置输入字体颜色
    [self.userNameTextField setTextColor:[UIColor whiteColor]];
    
    
    
    [self.view addSubview:self.userNameTextField];
    
    
    
    self.userNameTextField.layer.cornerRadius=8.0f;
    self.userNameTextField.layer.masksToBounds=YES;
    self.userNameTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.userNameTextField.layer.borderWidth= 1.0f;
    
    
    //password
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.size = CGSizeMake(250, 35);
    self.passwordTextField.center = CGPointMake(self.view.center.x, 260);
    // self.passwordTextField.placeholder = @"请输入密码";
    // self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.textColor = [UIColor colorWithRed:230/256.0 green:230/256.0 blue:230/256.0 alpha:1] ;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.layer.cornerRadius = 3;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.alpha = 0.7;
    
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
    //remember passWord
    UIButton  *rememberPasswordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rememberPasswordBtn.size = CGSizeMake(130, 30);
    rememberPasswordBtn.center = CGPointMake(self.view.center.x - 90, 300);
    rememberPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rememberPasswordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rememberPasswordBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    //    [rememberPasswordBtn addTarget:self action:@selector(rememberPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberPasswordBtn];
    
    
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.size = CGSizeMake(250, 30);
    self.loginButton.center = CGPointMake(self.view.center.x, 340);
    self.loginButton.backgroundColor = [UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    //注册按钮
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.size = CGSizeMake(250, 33);
    self.registerButton.center = CGPointMake(self.view.center.x, 390);
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.registerButton setTitle:@"没有帐号，注册一个" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1] forState:UIControlStateNormal];
    //self.registerButton.layer.cornerRadius = 3;
    self.registerButton.layer.masksToBounds = YES;
    //  self.registerButton.backgroundColor = [UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1];
    
    
    self.registerButton.layer.cornerRadius=8.0f;
    self.registerButton.layer.masksToBounds=YES;
    self.registerButton.layer.borderColor= [[UIColor grayColor]CGColor];
    //[[UIColor grayColor]CGColor];
    self.registerButton.layer.borderWidth= 1.0f;
    
    
    
    
    [self.registerButton addTarget:self action:@selector(signupClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    [self.userNameTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
#warning testing
    //    self.userNameTextField.text = @"13125197350";
    //    self.passwordTextField.text = @"123456";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end

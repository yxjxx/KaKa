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
//    UILabel *label = [[UILabel alloc]init];
//    label.text = @"aaaa";
//    label.textColor = [UIColor whiteColor];
  
    // UIImage *loginBackPic = [UIImage imageNamed:@"logBg"];
   // self.view.backgroundColor = [UIColor redColor];
   // self.backgroundLogin.image = loginBackPic;
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"logBg"]];
    //1. self.view.backgroundColor = [UIColor colorWithPatternImage:loginBackPic];
    //2.self.view.layer.contents = (id) loginBackPic.CGImage;
    /*3
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logBg"]];
    imageView.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:imageView];
   .*/
    /*  /4 .一
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"logBg"]];
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
     myView.backgroundColor = bgColor ;
    [self.view addSubview:myView];
    */
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"logBg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    self.navigationController.navigationBarHidden = YES;
   // [self.view addSubview:self.backgroundLogin];
    [self settingButtons];
}

- (void) settingButtons {
    
    //userName
    UILabel *userNameLabel = [[UILabel alloc]init];
    userNameLabel.size = CGSizeMake(80, 30);
    userNameLabel.center = CGPointMake(self.view.center.x - 80, 200);
    userNameLabel.text = @"用户名";
    userNameLabel.alpha = 0.7;
    [self.view addSubview:userNameLabel];
//    self.backgroundLogin
    self.userNameTextField = [[UITextField alloc] init];
    self.userNameTextField.size = CGSizeMake(250, 30);
    self.userNameTextField.center = CGPointMake(self.view.center.x, 240);
    self.userNameTextField.placeholder = @"username";
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.textColor = [UIColor blackColor];
    self.userNameTextField.layer.cornerRadius = 3;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.alpha = 0.3;
    [self.view addSubview:self.userNameTextField];
    //password
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.size = CGSizeMake(80, 30);
    passwordLabel.center = CGPointMake(self.view.center.x - 80, 280);
    passwordLabel.text = @"密码";
    passwordLabel.alpha = 0.7;
    [self.view addSubview:passwordLabel];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.size = CGSizeMake(250, 30);
    self.passwordTextField.center = CGPointMake(self.view.center.x, 320);
    self.passwordTextField.placeholder = @"password";
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.layer.cornerRadius = 3;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.alpha = 0.3;
    [self.view addSubview:self.passwordTextField];
    //remember passWord
    UIButton  *rememberPasswordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rememberPasswordBtn.size = CGSizeMake(130, 30);
    rememberPasswordBtn.center = CGPointMake(self.view.center.x - 90, 360);
    rememberPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rememberPasswordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rememberPasswordBtn setTitle:@"记住密码" forState:UIControlStateNormal];
//    [rememberPasswordBtn addTarget:self action:@selector(rememberPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberPasswordBtn];
    

    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.size = CGSizeMake(250, 30);
    self.loginButton.center = CGPointMake(self.view.center.x, 400);
    self.loginButton.backgroundColor = [UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTitle:@"Log in now!" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.loginButton.layer.shadowOffset = CGSizeMake(.0f,2.5f);
//    self.loginButton.layer.shadowRadius = 1.1f;
//    self.loginButton.layer.shadowOpacity =214.2f;
//    self.loginButton.layer.shadowColor = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
//    //self.loginButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:viewCheck.bounds].CGPath;
    
    
//    self.loginButton.layer.shadowOffset = CGSizeMake(.0f,2.5f);
//    self.loginButton.layer.shadowRadius = 1.5f;
//    self.loginButton.layer.shadowOpacity = .9f;
//    self.loginButton.layer.shadowColor = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
//    //self.loginButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:viewCheck.bounds].CGPath;
    
    
    [self.view addSubview:self.loginButton];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.size = CGSizeMake(250, 30);
    self.registerButton.center = CGPointMake(self.view.center.x, 460);
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerButton.layer.cornerRadius = 3;
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.backgroundColor = [UIColor colorWithRed:217/256.0 green:99/256.0 blue:91/256.0 alpha:1];
    
    [self.registerButton addTarget:self action:@selector(signupClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];

    [self.userNameTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
#warning testing
    self.userNameTextField.text = @"13125197350";
    self.passwordTextField.text = @"123456";
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
            
            
            [self loginSuccess];
        }  else {
            [SVProgressHUD showErrorWithStatus:@"密码或帖号错了"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail, Error: %@", error);
    }];
}

- (void)loginSuccess{
    //after login success, jump to mainpage
//    self.tabBarController.selectedIndex = 0;
    [self.tabBarController setSelectedIndex:0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%s", __func__);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [defaults boolForKey:@"isLog"];
    if (isLogin) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

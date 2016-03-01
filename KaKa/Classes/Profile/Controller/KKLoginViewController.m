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


@interface KKLoginViewController()

@property (nonatomic, strong) UILabel *         mainTitleLabel;
@property (nonatomic, strong) UITextField *     userNameTextField;
@property (nonatomic, strong) UITextField *     passwordTextField;
@property (nonatomic, strong) UIButton *        loginButton;
@property (nonatomic, strong) UIButton *        registerButton;

@end

@implementation KKLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self settingButtons];
}

- (void) settingButtons {
    self.mainTitleLabel = [[UILabel alloc] init];
    self.mainTitleLabel.size = CGSizeMake(200, 50);
    self.mainTitleLabel.center = CGPointMake(self.view.center.x, 100);
    self.mainTitleLabel.text = @"Log in";
    self.mainTitleLabel.textColor = [UIColor whiteColor];
    self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.mainTitleLabel];
    
    self.userNameTextField = [[UITextField alloc] init];
    self.userNameTextField.size = CGSizeMake(250, 30);
    self.userNameTextField.center = CGPointMake(self.view.center.x, 150);
    self.userNameTextField.placeholder = @"username";
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.textColor = [UIColor blackColor];
    self.userNameTextField.layer.cornerRadius = 3;
    [self.view addSubview:self.userNameTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.size = CGSizeMake(250, 30);
    self.passwordTextField.center = CGPointMake(self.view.center.x, 200);
    self.passwordTextField.placeholder = @"password";
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.layer.cornerRadius = 3;
    [self.view addSubview:self.passwordTextField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.size = CGSizeMake(100, 50);
    self.loginButton.center = CGPointMake(self.view.center.x, 250);
    [self.loginButton setTitle:@"Log in now!" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.size = CGSizeMake(100, 30);
    self.registerButton.center = CGPointMake(self.view.center.x, 300);
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(signupClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];

    
#warning testing
    self.userNameTextField.text = @"13125197350";
    self.passwordTextField.text = @"123456";
}

- (void)signupClicked {
    
    KKSignupViewController *signUpVc = [[KKSignupViewController alloc] init];
    
    [self.navigationController pushViewController:signUpVc animated:YES];
}

- (void)loginClicked {
    NSLog(@"%s", __func__);
    

    if ([[self.userNameTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""]) {
        alert(@"Please enter Email and password");
        return;
    }else{
        [self sendLoginRequest];
    }

   
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
            [defaults setObject:responseObject[@"ext_data"][kUsernameKey] forKey:kUsernameKey];
            [defaults synchronize];
            
            [self loginSuccess];
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



@end

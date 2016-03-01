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

@implementation KKLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self settingButtons];
}

- (void) settingButtons {
    UILabel *useMyAccount = [[UILabel alloc]init];
    useMyAccount.text = @"Log in now";
    useMyAccount.backgroundColor = [UIColor greenColor];
    useMyAccount.size = CGSizeMake(240, 40);
    useMyAccount.center = CGPointMake(190, 60);
    [self.view addSubview:useMyAccount];
    
    // 按扭 account and code
    UILabel *lblAccount = [[UILabel alloc]initWithFrame:CGRectMake(25, 110, 90, 40)];
    lblAccount.text = @"account:";
    
    [self.view addSubview:lblAccount];
    
    UITextField *textAccount = [[UITextField alloc]initWithFrame:CGRectMake(110, 110, 230, 40)];
    textAccount.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textAccount];
    
    
    UILabel *lblCode = [[UILabel alloc]init];
    lblCode.size = CGSizeMake(90, 40);
    lblCode.center = CGPointMake(68, 190);
    lblCode.text = @"code:";
    [self.view addSubview:lblCode];
    
    UITextField *textCode = [[UITextField alloc]init];
    textCode.size = CGSizeMake(230, 40);
    textCode.center = CGPointMake(225, 190);
    textCode.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textCode];
    
    
    UIButton *btnSignIn = [[UIButton alloc]init];
    btnSignIn.frame = CGRectMake(150, 330, 100, 40);
    btnSignIn.backgroundColor = [UIColor redColor];
    [btnSignIn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [btnSignIn setTitle:@"Login" forState:UIControlStateNormal];
    [self.view addSubview:btnSignIn];
    
    
    UIButton *btnSignUp = [[UIButton alloc]init];
    btnSignUp.frame = CGRectMake(70, 590, 280, 30);
    btnSignUp.backgroundColor = [UIColor redColor];
    [btnSignUp setTitle:@"No account, signup now." forState:UIControlStateNormal];
    [btnSignUp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [btnSignUp addTarget:self action:@selector(clickSignup) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnSignUp];
}

- (void)clickSignup {
    
    KKSignupViewController *signUpVc = [[KKSignupViewController alloc] init];
    
    [self.navigationController pushViewController:signUpVc animated:YES];
}

- (void)clickLogin {
    NSLog(@"%s", __func__);
    
    //after login success, jump to mainpage
    self.tabBarController.selectedIndex = 0;
}


@end

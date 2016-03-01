//
//  KKSignupViewController.m
//  KaKa
//
//  Created by yxj on 3/1/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKSignupViewController.h"

@implementation KKSignupViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    [self settingButtons];
}

- (void) settingButtons {
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.frame = CGRectMake(120, 50, 150, 50);
    lblTitle.text = @"欢迎注册";
    [self.view addSubview:lblTitle];
    
    //accout field
    UILabel *lblAccount = [[UILabel alloc]initWithFrame:CGRectMake(25, 110, 90, 40)];
    lblAccount.text = @"account:";
    
    [self.view addSubview:lblAccount];
    UITextField *textAccount = [[UITextField alloc]initWithFrame:CGRectMake(110, 110, 230, 40)];
    textAccount.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textAccount];
    //code1
    UILabel *lblCode1 = [[UILabel alloc]init];
    lblCode1.size = CGSizeMake(90, 40);
    lblCode1.center = CGPointMake(68, 190);
    lblCode1.text = @"code:";
    [self.view addSubview:lblCode1];
    
    UITextField *textCode1 = [[UITextField alloc]init];
    textCode1.size = CGSizeMake(230, 40);
    textCode1.center = CGPointMake(225, 190);
    textCode1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textCode1];
    //code2,telePhone
    UILabel *lblTelePhone = [[UILabel alloc]init];
    lblTelePhone.size = CGSizeMake(90, 40);
    lblTelePhone.center = CGPointMake(68, 250);
    lblTelePhone.text = @"telephone:";
    [self.view addSubview:lblTelePhone];
    
    UITextField *textCode2 = [[UITextField alloc]init];
    textCode2.size = CGSizeMake(230, 40);
    textCode2.center = CGPointMake(225, 250);
    textCode2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textCode2];
    
    
    // 注册验证 afnetworking :verifyAFN
    UIButton *verifyAFN = [[UIButton alloc]initWithFrame:CGRectMake(100, 290, 100, 30)];
    verifyAFN.backgroundColor = [UIColor redColor];
    [verifyAFN setTitle:@"确认注册" forState:UIControlStateNormal];
    [verifyAFN setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [verifyAFN addTarget:self action:@selector(clickSignupNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verifyAFN];
    
    
    //back
    UIButton *btnFinishSignUp = [[UIButton alloc]initWithFrame:CGRectMake(100, 390, 100, 30)];
    btnFinishSignUp.backgroundColor = [UIColor redColor];
    [btnFinishSignUp setTitle:@"Have account, login now." forState:UIControlStateNormal];
    [btnFinishSignUp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [btnFinishSignUp addTarget:self action:@selector(loginNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFinishSignUp];
}

- (void) loginNow {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) clickSignupNow {
    NSLog(@"%s", __func__);
}


@end

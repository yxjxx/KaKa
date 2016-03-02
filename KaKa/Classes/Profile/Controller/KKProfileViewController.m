//
//  KKProfileViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKProfileViewController.h"
#import "KKLoginViewController.h"

@interface KKProfileViewController()

@property (nonatomic, assign) BOOL *isLogin;

@end

@implementation KKProfileViewController

- (BOOL *)isLogin{
    _isLogin = FALSE;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return _isLogin;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    self.isLogin = FALSE;
    if (self.isLogin) {
//        [self setProfileView]
        NSLog(@"%@", @"is login");

    } else{
        KKLoginViewController *loginVC = [[KKLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC  animated:NO];
        [self setProfileView];
    }
    

}

- (void) setTopInformation {
    
    UIView *settingMyIcon = [[UIView alloc]init];
    settingMyIcon.size = CGSizeMake(self.view.width, 140);
    settingMyIcon.center = CGPointMake(self.view.width / 2, 80);
    settingMyIcon.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:settingMyIcon];
    //icon
    UIImageView *imgIcon = [[UIImageView alloc]init];
    imgIcon.image = [UIImage imageNamed:@"panda"];
    imgIcon.size = CGSizeMake(50, 50);
    imgIcon.center = CGPointMake(35, 70);
    [settingMyIcon addSubview:imgIcon];
    
    UILabel *lblNickName = [[UILabel alloc]init];
    lblNickName.size = CGSizeMake(260, 40);
    lblNickName.center = CGPointMake(self.view.width / 2, 40);
    //这里传入nickName的参数
    lblNickName.text = @"welcome, here is your nick name";
    [settingMyIcon addSubview:lblNickName];
    
    // 右上角，setting Button
    UIButton *btnOptions = [[UIButton alloc]init];
    btnOptions.size = CGSizeMake(45, 45);
    btnOptions.center = CGPointMake(self.view.width -  22.5, 22.5);
    [btnOptions setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [settingMyIcon addSubview:btnOptions];
    [btnOptions addTarget:self action:@selector(clickOptions) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNumbersOfFollowings = [[UILabel alloc]init];
    lblNumbersOfFollowings.size = CGSizeMake(260, 30);
    lblNumbersOfFollowings.center = CGPointMake(self.view.width / 2 + 30, 70);
    lblNumbersOfFollowings.text = @"posts:   followers:  following:";
    
    [settingMyIcon addSubview:lblNumbersOfFollowings];
    //posts ,follows
    UITextField *text1post = [[UITextField alloc]init];
    UITextField *text2followers = [[UITextField alloc]init];
    UITextField *text3following = [[UITextField alloc]init];
    text1post.size = CGSizeMake(80, 30);
    text2followers.size = CGSizeMake(80, 30);
    text3following.size = CGSizeMake(80, 30);
    text1post.center = CGPointMake(150, 100);
    text2followers.center = CGPointMake(230, 100);
    text3following.center = CGPointMake(300, 100);
    text1post.text = @"5";
    text2followers.text = @"9";
    text3following.text = @"0";
    [settingMyIcon addSubview:text1post];
    [settingMyIcon addSubview:text2followers];
    [settingMyIcon addSubview:text3following];
    //
    //    //
    //    UILabel *lblTitle = [[UILabel alloc]init];
    //    lblTitle.size = CGSizeMake(210, 51);
    //    lblTitle.center = CGPointMake(self.view.width / 2, 160);
    //    lblTitle.text = @"my Name and Icon";
    //    lblTitle.backgroundColor = [UIColor grayColor];
    //    [settingMyIcon addSubview:lblTitle];
    
    
    
}
- (void)setProfileView {
    [self setTopInformation ];
    UIButton *btnLoginIn = [[UIButton alloc]initWithFrame:CGRectMake(50, 500, 150, 50)];
    [btnLoginIn setTitle:@"Login Out" forState:UIControlStateNormal];
    [btnLoginIn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnLoginIn addTarget:self action:@selector(clickLoginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoginIn];
    
}


- (void) clickLoginOut {
   KKLoginViewController *loginVc = [[KKLoginViewController alloc]init];
   [self presentViewController:loginVc animated:YES completion:^{
    
     }];
}

- (void) clickOptions {
//    NSLog(@"click options");
//    KKOptionTableVC *optionVc = [[KKOptionTableVC alloc]init];
//    // [self.navigationController pushViewController:optionVc animated:YES];
//    [self presentViewController:optionVc animated:YES completion:^{
//        
    
//    }];
}
-(void)saveNSUserDefaults
{
    BOOL haveAccount = NO;
    NSString *account = @"kqy";
    NSString *code = @"kqy";
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setBool:haveAccount forKey:@"ifHaveAccount"];
    [userDefaults setObject:account forKey:@"AccountKqy"];
    [userDefaults setObject:code forKey:@"CodeKqy"];
    
    //这里建议同步存储到磁盘中，但是不是必须的
    [userDefaults synchronize];
    
}

//从NSUserDefaults中读取数据
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    //my kqy 1
    NSString *myString1 = [userDefaultes stringForKey:@"myString"];
    NSLog(@"acquire mystring1:%@",myString1);
    //读取数据到各个label中
    //读取整型int类型的数据
    NSInteger myInteger = [userDefaultes integerForKey:@"myInteger"];
//    NSLog(@"acquire:int:%d",myInteger);
    
}




@end

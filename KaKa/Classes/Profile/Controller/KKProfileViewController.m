//
//  KKProfileViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKProfileViewController.h"
#import "KKLoginViewController.h"
#import "KKOptionsTableVC.h"
#import "Constants.h"
@interface KKProfileViewController()

@property (nonatomic, assign) BOOL isLogin;

@end

@implementation KKProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:NO];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isLogin = [defaults boolForKey:@"isLog"];
    
    if (self.isLogin) {
        
        [self setProfileView];
        NSLog(@"%@", @"is login");
        
    } else{
        KKLoginViewController *loginVC = [[KKLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC  animated:NO];
    }

    
}

- (void) setTopInformation {
    
    UIView *settingMyIcon = [[UIView alloc]init];
    settingMyIcon.size = CGSizeMake(self.view.width, 140);
    settingMyIcon.center = CGPointMake(kScreenWidth / 2, 130 + kStatusBarHeight);
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
    
    // 右上角，setting Button.写到navigationItem.rightBarButtonItem中
    self.view.backgroundColor = [UIColor purpleColor];
    UIBarButtonItem *btnOptions = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(clickOptions) ];
    self.navigationItem.rightBarButtonItem = btnOptions;
   
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
    
    
}
- (void)setProfileView {
    
    [self setTopInformation ];
   
    
}


- (void) clickLoginOut {
     KKLoginViewController *loginVc = [[KKLoginViewController alloc]init];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUsernameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLog"];
//   [self presentViewController:loginVc animated:YES completion:^{
//    
//     }];
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (void) clickOptions {

    KKOptionsTableVC *optionVc = [[KKOptionsTableVC alloc]init];
    [self.navigationController pushViewController:optionVc animated:YES];
    
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

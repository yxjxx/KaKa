//
//  KKMainPageViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKMainPageViewController.h"

@implementation KKMainPageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    
#warning testing
    self.tabBarController.selectedIndex = 3;
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:kUsernameKey];
    //    self.title = username;
    if ([username isEqualToString:@""]) {
        NSLog(@"MainPage: %@", username);
    } else{
        NSLog(@"MainPage: %@", username);
    }

}

@end

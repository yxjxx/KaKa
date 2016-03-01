//
//  KKMainPageViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKMainPageViewController.h"

@interface KKMainPageViewController()

@property (nonatomic, copy) NSString *username;

@end

@implementation KKMainPageViewController

- (NSString *)username{
    if (!_username) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _username = [defaults objectForKey:kUsernameKey];
    }
    
    return _username;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = self.username;
    [self.navigationController.tabBarItem setBadgeValue:@"3"];
    
    
    //self.tabBarController.selectedIndex = 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *badgeNumber = @(indexPath.row + 1);
    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", badgeNumber]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ VC cell %@", [self class], @(indexPath.row)];
    return cell;
}


@end

//
//  KKFriendsViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKFriendsViewController.h"
#import "KKNetwork.h"
#import "KKFriendModel.h"
#import "KKFriendTableViewCell.h"
#import "KKFriendProfileViewController.h"

@interface KKFriendsViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *friendsTableView;
@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (nonatomic, copy) NSString *kidForFriendsVC;
@property (nonatomic, strong) UIButton *notLoginHintBtn;

@end

@implementation KKFriendsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.kidForFriendsVC = [[NSUserDefaults standardUserDefaults] objectForKey:@"kid"];
    if (self.kidForFriendsVC == nil) {
        [self.view removeAllSubViews];
        [self.view addSubview:self.notLoginHintBtn];
    } else{
        [self.view removeAllSubViews];
        [self.view addSubview:self.friendsTableView];
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
    //返回按钮，navigationItem
    [self setNavigationItem];
     
    
    self.kidForFriendsVC = [[NSUserDefaults standardUserDefaults] objectForKey:@"kid"];
    if (self.kidForFriendsVC == nil) {
        return;
    } else{
        [self.friendsArray removeAllObjects];
        [self pullFriendsList];
    }
}

- (void)pullFriendsList{
    self.kidForFriendsVC = [[NSUserDefaults standardUserDefaults] objectForKey:@"kid"];
    if (self.kidForFriendsVC == nil) {
        return;
    } else{
        __weak typeof(self) weakSelf = self;
        //TODO: modify to getFollowing
        [[KKNetwork sharedInstance] getFansListWithKid:self.kidForFriendsVC completeSuccessed:^(NSDictionary *responseJson) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf pullFriendsListSuccess:responseJson];
            });
        } completeFailed:^(NSString *failedStr) {
            [SVProgressHUD showInfoWithStatus:failedStr];
        }];
    }
}

- (void)pullFriendsListSuccess:(NSDictionary *)responseJson{
    if ([responseJson[@"data"] isEqual:[NSNull null]]) {
        [SVProgressHUD showErrorWithStatus:@"No more data"];
        return;
    } else{
        NSArray *arr = [(NSArray *) responseJson[@"data"] mutableCopy];
        for (NSDictionary *dict in arr) {
            KKFriendModel *theFriend = [KKFriendModel friendWithDict:dict];
            [self.friendsArray addObject:theFriend];
        }
        [self.friendsTableView reloadData];
    }
}

- (UIButton *)notLoginHintBtn{
    if (_notLoginHintBtn == nil) {
        _notLoginHintBtn = [[UIButton alloc] init];
        _notLoginHintBtn.center = self.view.center;
        //TODO: button frame and color adjust
        _notLoginHintBtn.size = CGSizeMake(100, 100);
        [_notLoginHintBtn setTitle:@"login now" forState:UIControlStateNormal];
        [_notLoginHintBtn setBackgroundColor:[UIColor redColor]];
        [_notLoginHintBtn addTarget:self action:@selector(clickNotLoginHintBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notLoginHintBtn;
}

- (void)clickNotLoginHintBtn{
    // jump to profile page
    self.tabBarController.selectedIndex = 3;
}

- (NSMutableArray *)friendsArray{
    if (_friendsArray == nil) {
        _friendsArray = [[NSMutableArray alloc] init];
    }
    return _friendsArray;
}



- (UITableView *)friendsTableView{
    if (_friendsTableView == nil) {
        CGFloat tableviewFrameY = 0;
        _friendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(kMagicZero, tableviewFrameY, kScreenWidth, kScreenHeight-tableviewFrameY-kTabBarHeight) style:UITableViewStylePlain];
        _friendsTableView.delegate = self;
        _friendsTableView.dataSource = self;
        _friendsTableView.backgroundColor =  [UIColor colorWithRed:30/256.0 green:30/256.0 blue:30/256.0 alpha:1];
        _friendsTableView.separatorColor = [UIColor colorWithRed:60/256.0 green:60/256.0 blue:60/256.0 alpha:0.8];
    }
    return _friendsTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendsArray.count;
}

- (KKFriendTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    KKFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KKFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    KKFriendModel *aFriendModel = self.friendsArray[indexPath.row];
    cell.friendModel = aFriendModel;
    
    //被选中的color:
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithRed:30/256.0 green:30/256.0 blue:30/256.0 alpha:1];
    cell.selectedBackgroundView = bgView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KKFriendModel *aFriendModel = self.friendsArray[indexPath.row];
    KKFriendProfileViewController *friendPVC = [[KKFriendProfileViewController alloc] init];
    friendPVC.friendModel = aFriendModel;
    
    //TODO: animation too slow
    [self.navigationController pushViewController:friendPVC animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void) setNavigationItem {
    //当前页面的 标题
    self.navigationItem.title = @"朋友圈";
    //返回页面的标题
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"朋友圈";
    self.navigationItem.backBarButtonItem = backItem;
    //返回的颜色
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:116/256.0 green:116/256.0 blue:117/256.0 alpha:1],UITextAttributeTextColor,nil]];
}

@end

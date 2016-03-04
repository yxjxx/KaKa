//
//  KKVoiceLibraryViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKVoiceLibraryViewController.h"
#import "KKAudioModel.h"
#import "KKAudioCell.h"    
#import "AFNetworking.h"
#import "KKNetwork.h"
#import <SVProgressHUD.h>
#import "MJRefresh.h"


@interface KKVoiceLibraryViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) UITableView *audioTableView;
@property (nonatomic, strong) NSMutableArray *audioArrays;
@property (nonatomic, assign) NSInteger audioPageNum;

@end


@implementation KKVoiceLibraryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = self.username;
    [self.navigationController.tabBarItem setBadgeValue:@"233"];
    
    [self.view addSubview:self.audioTableView];
    NSLog(@"%@", self.audioTableView);
    

    self.audioPageNum = 0;
    
    __weak typeof(self) weakSelf = self;
    self.audioTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullDownRefresh];
    }];
    self.audioTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.audioPageNum++;
        [weakSelf pullUpRefreshWithPageNum:self.audioPageNum];
    }];
    
    [self.audioTableView.mj_header beginRefreshing];
    
}

- (void)pullUpRefreshWithPageNum:(NSInteger)pageNum{
    __weak typeof(self) weakSelf = self;
    [[KKNetwork sharedInstance] getAudioArrayDictWithPageNum:[NSString stringWithFormat:@"%ld", pageNum] completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pullUpRefreshSuccess:responseJson];
            [weakSelf.audioTableView.mj_footer endRefreshing];
        });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
}

- (void)pullUpRefreshSuccess:(NSDictionary *)responseJson{
    NSArray *arr = [(NSArray *) responseJson[@"data"] mutableCopy];
    for (NSDictionary *dict in arr) {
        KKAudioModel *theAudio = [KKAudioModel audioWithDict:dict];
        [self.audioArrays addObject:theAudio];
    }
#warning debuging
//    NSLog(@"self.audiosArray : %@",self.audioArrays);
    [self.audioTableView reloadData];
}

- (void)pullDownRefresh{
    __weak typeof(self) weakSelf = self;
    [[KKNetwork sharedInstance] getAudioArrayDictWithPageNum:@"0" completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pullDownRefreshSuccess:responseJson];
            [weakSelf.audioTableView.mj_header endRefreshing];
        });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
}

- (void) pullDownRefreshSuccess:(NSDictionary *)responseJson {
    [self.audioArrays removeAllObjects];
    NSArray *arr = [(NSArray *) responseJson[@"data"] mutableCopy];
    for (NSDictionary *dict in arr) {
        KKAudioModel *theAudio = [KKAudioModel audioWithDict:dict];
        [self.audioArrays addObject:theAudio];
    }
#warning debuging
//    NSLog(@"self.audiosArray : %@",self.audioArrays);
    [self.audioTableView reloadData];
}

- (UITableView *)audioTableView {
    if (_audioTableView == nil) {
        //???: why 0?
//        CGFloat tableviewFrameY = kStatusBarHeight + kNavgationBarHeight;
        CGFloat tableviewFrameY = 0;
        _audioTableView = [[UITableView alloc] initWithFrame:CGRectMake(kMagicZero, tableviewFrameY, kScreenWidth, kScreenHeight-tableviewFrameY-kTabBarHeight) style:UITableViewStylePlain];
        _audioTableView.delegate = self;
        _audioTableView.dataSource = self;
    }
    return _audioTableView;
}
- (NSMutableArray *)audioArrays {
    if (_audioArrays == nil) {
        _audioArrays = [NSMutableArray array];
    }
    return _audioArrays;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.audioArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CELL";
    KKAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KKAudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    KKAudioModel *audioModel = self.audioArrays[indexPath.row];
    cell.aAudioModel = audioModel;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *badgeNumber = @(indexPath.row + 1);
    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", badgeNumber]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (NSString *)username{
    if (!_username) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _username = [defaults objectForKey:kUsernameKey];
    }
    return _username;
}
@end

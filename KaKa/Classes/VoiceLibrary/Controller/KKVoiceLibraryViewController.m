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
#import "KKAudioRecordModel.h"
#import "AppDelegate.h"
#import <AVFoundation/AVAudioPlayer.h>


@interface KKVoiceLibraryViewController() <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) UITableView *audioTableView;
@property (nonatomic, strong) NSMutableArray *audioArrays;
@property (nonatomic, assign) NSInteger audioPageNum;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end


@implementation KKVoiceLibraryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = self.username;
 
    [self.view addSubview:self.audioTableView];    

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
    
    KKAudioModel *audioModel = self.audioArrays[indexPath.row];
    NSString *audioLocalName = [audioModel.audioPath lastPathComponent];

    if ([[KKAudioRecordModel sharedInstance] isLocalAudioExistWithFileName:audioLocalName]) {
//        if (self.audioPlayer.isPlaying) {
//            
//        }
        
        //Play audio
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSString *audioFullFilePathStr = [appDelegate.audio_dir stringByAppendingPathComponent:[audioModel.audioPath lastPathComponent]];
        NSURL *audioFullFilePath = [NSURL URLWithString:audioFullFilePathStr];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFullFilePath error:nil];
        
#warning debuging
        NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.audioPlayer.numberOfChannels,self.audioPlayer.duration];
        NSLog(@"%@",msg);
        
        // 设置循环播放
        self.audioPlayer.numberOfLoops = 0;//-1 循环播放
        self.audioPlayer.delegate = self;
        // 开始播放
        [self.audioPlayer play];
        //TODO:  在 delegate 中处理中断等

    } else{
        [self downloadSelectedAudioWithKKAudioModel:audioModel];
    }
}

- (void)downloadSelectedAudioWithKKAudioModel:(KKAudioModel *)audioModel{
    NSString *audioRemoteURL = audioModel.audioPath;
    [SVProgressHUD showWithStatus:@"downloading audio"];
    
    [[KKNetwork sharedInstance] downloadRemoteAudioWithURL:audioRemoteURL completeSuccessed:^(NSString *successStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"download success"];
            [[KKAudioRecordModel sharedInstance] updateGlobalAudioLibraryData:audioModel];
        });
    } completeFailed:^(NSString *failedStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"download error"];
        });
    }];
    
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

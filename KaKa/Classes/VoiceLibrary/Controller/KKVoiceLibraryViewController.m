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
#import "KKNetworkAudio.h"
#import "HMSegmentedControl.h"

@interface KKVoiceLibraryViewController()
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) UITableView *audioTableView;
@property (nonatomic, strong) NSMutableArray *audioArrays;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger *segIndex;

@end


@implementation KKVoiceLibraryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = self.username;
    [self.navigationController.tabBarItem setBadgeValue:@"22"];
    
    [self.view addSubview:self.audioTableView];
    [self pullToRefresh];
    
}

- (void)pullToRefresh{
    __weak KKVoiceLibraryViewController *weakSelf = self;
    [[KKNetworkAudio  sharedInstance] getVideoArrayDictWithOrder:[NSString stringWithFormat:@"%ld", self.segIndex + 1]
                                                      page:@"2"
                                         completeSuccessed:^(NSDictionary *responseJson) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakSelf pullToRefreshSuccess:responseJson];
                                             });
                                         } completeFailed:^(NSString *failedStr) {
                                             
                                         }];
}

- (void) pullToRefreshSuccess:(NSDictionary *)responseJson {
    [self.audioArrays removeAllObjects];
    NSArray *arr = [(NSArray *) responseJson[@"data"] mutableCopy];
    for (NSDictionary *dict in arr) {
        KKAudioModel *theAudio = [KKAudioModel audioWithDict:dict];
        [self.audioArrays addObject:theAudio];
    }
    NSLog(@"self.audiosArray : %@",self.audioArrays);
    [self.audioTableView reloadData];
}

- (NSInteger *)segIndex {
    return _segmentedControl.selectedSegmentIndex;
}



- (UITableView *)audioTableView {
    if (_audioTableView == nil) {
        _audioTableView == [[UITableView alloc] initWithFrame:CGRectMake(0, 33, 375, 667-80) style:UITableViewStylePlain];
        _audioTableView.delegate = self;
        _audioTableView.dataSource = self; //并不是self.audioTableView
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
}   ///这个并不会自动补全

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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSNumber *badgeNumber = @(indexPath.row + 1);
//    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", badgeNumber]];
//    
//    KKVideoModel *videoModel = self.videosArray[indexPath.row];
//    //    videoModel.videoPath
//    KKPlayVideoViewController *playVideoVC = [[KKPlayVideoViewController alloc] init];
//    playVideoVC.videoFullPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kPathOfVideoInServer, videoModel.videoPath]];
//    [self.navigationController pushViewController:playVideoVC animated:YES];
//}这有playVideo界面

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *badgeNumber = @(indexPath.row + 1);
//    [self.navigationController.tabBarItem setBadgeValue:[NSString   stringWithFormat:@"%@%@", kPathOfVideoInServer,videoModel.videoPath]];
//    [self.navigationController pushViewController:playVideoVC animated:YES];  这有playVideo界面，这里要改为play Audio
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

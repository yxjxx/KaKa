//
//  KKMainPageViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKMainPageViewController.h"
#import "KKPlayVideoViewController.h"
#import "AFNetworking.h"
#import "HMSegmentedControl.h"
#import "KKVideoModel.h"
#import "KKNetwork.h"
#import "KKVideoCell.h"


@interface KKMainPageViewController() <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) UITableView *videoTableView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger segIndex;
@property (nonatomic, strong) NSMutableArray *videosArray;

@end

@implementation KKMainPageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.username;
    [self.navigationController.tabBarItem setBadgeValue:@"3"];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.videoTableView];
    
    [self pullToRefresh];
}

- (void)pullToRefresh{
    __weak KKMainPageViewController *weakSelf = self;
    [[KKNetwork sharedInstance] getVideoArrayDictWithOrder:[NSString stringWithFormat:@"%ld", self.segIndex + 1]
                                                      page:@"2"
                                         completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pullToRefreshSuccess:responseJson];
        });
    } completeFailed:^(NSString *failedStr) {

    }];
}

- (void)pullToRefreshSuccess:(NSDictionary *)responseJson{
    [self.videosArray removeAllObjects];
    NSArray *arr = [(NSArray *)responseJson[@"data"] mutableCopy];
    for (NSDictionary *dict in arr) {
        KKVideoModel *theVideo = [KKVideoModel videoWithDict:dict];
        [self.videosArray addObject:theVideo];
    }
    NSLog(@"self.videosArray %@", self.videosArray);
    [self.videoTableView reloadData];
}


- (NSInteger)segIndex{
    return _segmentedControl.selectedSegmentIndex;
}


- (NSArray *)videosArray{
    if (_videosArray == nil) {
        _videosArray = [NSMutableArray array];
    }
    return _videosArray;
}

- (UITableView *)videoTableView{
    if (_videoTableView == nil) {
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), 375, 667-80) style:UITableViewStylePlain];

        self.videoTableView.delegate = self;
        self.videoTableView.dataSource = self;
    }
    return _videoTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.videosArray count];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segment{
    self.segIndex = segment.selectedSegmentIndex;
    [self pullToRefresh];
//    [self.videoTableView reloadData];
    
}


- (NSString *)username{
    if (!_username) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _username = [defaults objectForKey:kUsernameKey];
    }
    return _username;
}

- (HMSegmentedControl *)segmentedControl{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] init];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"推荐", @"热门"]];
        _segmentedControl.frame = CGRectMake(kMagicZero, kStatusBarHeight + kNavgationBarHeight, kScreenWidth, 60);
        _segmentedControl.backgroundColor = [UIColor redColor];
        _segmentedControl.selectionStyle = HMSegmentedControlBorderTypeTop;
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    KKVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[KKVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    KKVideoModel *videoModel = self.videosArray[indexPath.row];
    
    cell.aVideoModel = videoModel;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *badgeNumber = @(indexPath.row + 1);
    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", badgeNumber]];
    
    KKVideoModel *videoModel = self.videosArray[indexPath.row];
//    videoModel.videoPath
    KKPlayVideoViewController *playVideoVC = [[KKPlayVideoViewController alloc] init];
    playVideoVC.videoFullPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kPathOfVideoInServer, videoModel.videoPath]];
    [self.navigationController pushViewController:playVideoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end

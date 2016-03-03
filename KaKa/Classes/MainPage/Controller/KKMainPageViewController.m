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
#import <SVProgressHUD.h>
#import "MJRefresh.h"


@interface KKMainPageViewController() <UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) UICollectionView *recommendVideoCollectionView0;
@property (nonatomic, strong) UICollectionView *hotVideoCollectionView1;
@property (nonatomic, strong) NSMutableArray *recommendVideosArray0;
@property (nonatomic, strong) NSMutableArray *hotVideoArray1;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger segIndex;
@property (nonatomic, assign) NSInteger recommendVideoPageNum;
@property (nonatomic, assign) NSInteger hotVideoPageNum;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation KKMainPageViewController

static NSString *ID = @"videoCell";

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.username;
    [self.navigationController.tabBarItem setBadgeValue:@"3"];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.hotVideoCollectionView1];
    [self.view addSubview:self.recommendVideoCollectionView0];
    
    
    [self.hotVideoCollectionView1 registerClass:[KKVideoCell class] forCellWithReuseIdentifier:ID];
    [self.recommendVideoCollectionView0 registerClass:[KKVideoCell class] forCellWithReuseIdentifier:ID];
    
    [self pullDownRefresh:0];
    [self pullDownRefresh:1];
    
    __weak typeof(self) weakSelf = self;
    self.recommendVideoCollectionView0.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullDownRefresh:0];
    }];
    
    self.hotVideoCollectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf pullDownRefresh:1];
    }];
    
    self.recommendVideoPageNum = 0;
    self.hotVideoPageNum = 0;
    self.recommendVideoCollectionView0.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.recommendVideoPageNum++;
        [weakSelf pullUpRefresh:0 withPageNum:self.recommendVideoPageNum];
    }];
    self.hotVideoCollectionView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.hotVideoPageNum++;
        [weakSelf pullUpRefresh:1 withPageNum:self.hotVideoPageNum];
    }];
}

- (void)pullUpRefresh:(NSInteger)segIndex withPageNum:(NSInteger)pageNum{
    __weak typeof(self) weakSelf = self;
    pageNum = segIndex == 0 ? self.recommendVideoPageNum : self.hotVideoPageNum;
    [[KKNetwork sharedInstance] getVideoArrayDictWithOrder:[NSString stringWithFormat:@"%ld", segIndex + 1] page:[NSString stringWithFormat:@"%ld", pageNum] completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf pullUpRefreshSuccess:responseJson withSegIndex:segIndex andPageNum:pageNum];
            [weakSelf.recommendVideoCollectionView0.mj_footer endRefreshing];
            [weakSelf.hotVideoCollectionView1.mj_footer endRefreshing];
             });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
}
                       
- (void)pullUpRefreshSuccess:(NSDictionary *)responseJson withSegIndex:(NSInteger)segIndex andPageNum:(NSInteger)pageNum{
    NSArray *arr = [(NSArray *)responseJson[@"data"] mutableCopy];
    
    if (segIndex == 0) {
        for (NSDictionary *dict in arr) {
            KKVideoModel *theVideo = [KKVideoModel videoWithDict:dict];
            [self.recommendVideosArray0 addObject:theVideo];
        }
        [self.recommendVideoCollectionView0 reloadData];
    } else{
        for (NSDictionary *dict in arr) {
            KKVideoModel *theVideo = [KKVideoModel videoWithDict:dict];
            [self.hotVideoArray1 addObject:theVideo];
        }
        [self.hotVideoCollectionView1 reloadData];
    }
}


- (void)pullDownRefresh:(NSInteger)segIndex{
    __weak KKMainPageViewController *weakSelf = self;
    [[KKNetwork sharedInstance] getVideoArrayDictWithOrder:[NSString stringWithFormat:@"%ld", segIndex + 1]
                                                      page:@"0"
                                         completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf pullDownRefreshSuccess:responseJson withSegIndex:segIndex];
            [weakSelf.recommendVideoCollectionView0.mj_header endRefreshing];
            [weakSelf.hotVideoCollectionView1.mj_header endRefreshing];
        });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
}

- (void)pullDownRefreshSuccess:(NSDictionary *)responseJson withSegIndex:(NSInteger)segIndex{
    NSArray *arr = [(NSArray *)responseJson[@"data"] mutableCopy];
    
    if (segIndex == 0) {
        //TODO:  在本地缓存最新的一页数据
//        [self cacheJsonData:arr withSegIndex:0];
        [self.recommendVideosArray0 removeAllObjects];

        for (NSDictionary *dict in arr) {
            KKVideoModel *theVideo = [KKVideoModel videoWithDict:dict];
            [self.recommendVideosArray0 addObject:theVideo];
        }
        [self.recommendVideoCollectionView0 reloadData];
        
    } else{
        [self.hotVideoArray1 removeAllObjects];

        for (NSDictionary *dict in arr) {
            KKVideoModel *theVideo = [KKVideoModel videoWithDict:dict];
            [self.hotVideoArray1 addObject:theVideo];
        }
        [self.hotVideoCollectionView1 reloadData];
    }

}


- (NSInteger)segIndex{
    return _segmentedControl.selectedSegmentIndex;
}


- (NSMutableArray *)recommendVideosArray0{
    if (_recommendVideosArray0 == nil) {
        _recommendVideosArray0 = [NSMutableArray array];
    }
    return _recommendVideosArray0;
}

- (NSMutableArray *)hotVideoArray1{
    if (_hotVideoArray1 == nil) {
        _hotVideoArray1 = [NSMutableArray array];
    }
    return _hotVideoArray1;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(kSnapshotWidth, kSnapshotWidth);
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    return _flowLayout;
}


- (UICollectionView *)recommendVideoCollectionView0{
    if (_recommendVideoCollectionView0 == nil) {
        _recommendVideoCollectionView0 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), kScreenWidth, kMainPageTableViewHeigh) collectionViewLayout:self.flowLayout];
        _recommendVideoCollectionView0.delegate = self;
        _recommendVideoCollectionView0.dataSource = self;
        _recommendVideoCollectionView0.backgroundColor = [UIColor blackColor];
    }
    return _recommendVideoCollectionView0;
}

- (UICollectionView *)hotVideoCollectionView1{
    if (_hotVideoCollectionView1 == nil) {
        _hotVideoCollectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenWidth, CGRectGetMaxY(self.segmentedControl.frame), kScreenWidth, kMainPageTableViewHeigh) collectionViewLayout:self.flowLayout];
        _hotVideoCollectionView1.delegate = self;
        _hotVideoCollectionView1.dataSource = self;
        _hotVideoCollectionView1.backgroundColor = [UIColor blackColor];
    }
    return _hotVideoCollectionView1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.segIndex == 0) {
        return self.recommendVideosArray0.count;
    } else{
        return self.hotVideoArray1.count;
    }
}

- (KKVideoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    if (self.segIndex == 0) {
        KKVideoModel *videoModel = self.recommendVideosArray0[indexPath.item];
        cell.aVideoModel = videoModel;
    } else{
        KKVideoModel *videoModel = self.hotVideoArray1[indexPath.item];
        cell.aVideoModel = videoModel;
    }
    return cell;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segment{
    self.segIndex = segment.selectedSegmentIndex;

//    [self.videoTableView reloadData];
    if (self.segIndex == 0) {
        
        self.recommendVideoCollectionView0.frame = CGRectMake(kMagicZero, CGRectGetMaxY(self.segmentedControl.frame), kScreenWidth, kMainPageTableViewHeigh);
        self.hotVideoCollectionView1.frame = CGRectMake(kScreenWidth, CGRectGetMaxY(self.segmentedControl.frame), kScreenWidth, kMainPageTableViewHeigh);
        self.recommendVideoCollectionView0.hidden = NO;
        self.hotVideoCollectionView1.hidden = YES;
//        [self.recommendVideoCollectionView0 reloadData];
    } else{
        
        self.recommendVideoCollectionView0.frame = CGRectMake(-kScreenWidth, CGRectGetMaxY(self.segmentedControl.frame), kScreenWidth, kMainPageTableViewHeigh);
        self.hotVideoCollectionView1.frame = CGRectMake(kMagicZero, CGRectGetMaxY(self.segmentedControl.frame), kScreenWidth, kMainPageTableViewHeigh);
        self.recommendVideoCollectionView0.hidden = YES;
        self.hotVideoCollectionView1.hidden = NO;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self.hotVideoCollectionView1 reloadData];
        });
    }
    
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
        _segmentedControl.frame = CGRectMake(kMagicZero, kStatusBarHeight + kNavgationBarHeight, kScreenWidth, kSegementControlHeight);
//        _segmentedControl.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
        _segmentedControl.selectionStyle = HMSegmentedControlBorderTypeTop;
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KKVideoModel *videoModel = self.recommendVideosArray0[indexPath.item];
    
    KKPlayVideoViewController *playVideoVC = [[KKPlayVideoViewController alloc] init];
    playVideoVC.videoModel = videoModel;
    [self.navigationController pushViewController:playVideoVC animated:YES];
}

@end

//
//  KKFriendProfileViewController.m
//  KaKa
//
//  Created by yxj on 3/9/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKFriendProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKProfileVideoCell.h"
#import "KKProfileVideoModel.h"
#import "MJRefresh.h"
#import <SVProgressHUD.h>
#import "KKNetwork.h"
#import "KKPlayVideoInProfileViewController.h"

static NSString *ID = @"videoCell";

@interface KKFriendProfileViewController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *followingNumLabel;
@property (nonatomic, strong) UILabel *followingStrLabel;
@property (nonatomic, strong) UILabel *fansNumLabel;
@property (nonatomic, strong) UILabel *fansStrLabel;

@property (nonatomic, strong) UICollectionView *myVideoCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *myVideoArray;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation KKFriendProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = self.friendModel.username;
    
    [self.view addSubview:self.topView];
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.friendModel.portrait] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.topView addSubview:self.portraitImageView];
    //TODO: followingNum数据修改
    self.followingNumLabel.text = self.friendModel.fans;
    [self.topView addSubview:self.followingNumLabel];
    [self.topView addSubview:self.followingStrLabel];
    self.fansNumLabel.text = self.friendModel.fans;
    [self.topView addSubview:self.fansNumLabel];
    [self.topView addSubview:self.fansStrLabel];
    [self.view addSubview:self.myVideoCollectionView];
    
    self.pageNum = -1;
    __weak typeof(self) weakSelf = self;
    self.myVideoCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum++;
        [weakSelf pullUpRefreshWithPageNum:weakSelf.pageNum];
    }];
    
    [self.myVideoCollectionView registerClass:[KKProfileVideoCell class] forCellWithReuseIdentifier:ID];
    
    [self.myVideoCollectionView.mj_footer beginRefreshing];
}

- (void)pullUpRefreshWithPageNum:(NSInteger)pageNum{
    __weak typeof(self) weakSelf = self;
    
    //TODO: 如果 kid 为空的异常处理
    [[KKNetwork sharedInstance] getVideosOfTheUserWithKid:self.friendModel.kid andPage:[NSString stringWithFormat:@"%ld", pageNum] andOrder:@"1" completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pullUpRefreshSuccess:responseJson WithPageNum:pageNum];
            [weakSelf.myVideoCollectionView.mj_footer endRefreshing];
        });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
}

- (void)pullUpRefreshSuccess:(NSDictionary *)responseJson WithPageNum:(NSInteger)pageNum{
    if ([responseJson[@"data"] isEqual:[NSNull null]]) {
        [SVProgressHUD showErrorWithStatus:@"No more data"];
        return;
    } else{
        NSArray *arr = [(NSArray *)responseJson[@"data"] mutableCopy];
        
        for (NSDictionary *dict in arr) {
            KKProfileVideoModel *theVideo = [KKProfileVideoModel videoWithDict:dict];
            [self.myVideoArray addObject:theVideo];
        }
        [self.myVideoCollectionView reloadData];
    }
    
    
}


- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        [_topView setFrame:CGRectMake(kMagicZero, kStatusBarHeight + kNavgationBarHeight, kScreenWidth, kProfileTopUIViewHeight)];
        _topView.backgroundColor = [UIColor colorWithRed:46/256.0 green:46/256.0 blue:46/256.0 alpha:1];
    }
    return _topView;
}

- (UIImageView *)portraitImageView{
    if (_portraitImageView == nil) {
        _portraitImageView = [[UIImageView alloc] init];
        _portraitImageView.size = CGSizeMake(85, 85);
        _portraitImageView.center = CGPointMake(kScreenWidth/2, 60);
        _portraitImageView.layer.cornerRadius = _portraitImageView.size.width/2;
        _portraitImageView.layer.masksToBounds = YES;
        //TODO: 添加边框
    }
    return _portraitImageView;
}

- (UILabel *)followingNumLabel{
    if (_followingNumLabel == nil) {
        _followingNumLabel = [[UILabel alloc] init];
        [_followingNumLabel setFrame:CGRectMake(kScreenWidth/2-85, 40, 25, 20)];
        _followingNumLabel.layer.cornerRadius = 2;
        _followingNumLabel.layer.masksToBounds = YES;
        _followingNumLabel.textAlignment = NSTextAlignmentCenter;
        [_followingNumLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
        _followingNumLabel.backgroundColor = [UIColor colorWithRed:182/256.0 green:71/256.0 blue:72/256.0 alpha:1];
    }
    return _followingNumLabel;
}

- (UILabel *)followingStrLabel{
    if (_followingStrLabel == nil) {
        _followingStrLabel = [[UILabel alloc] init];
        _followingStrLabel.frame = CGRectMake(kScreenWidth/2-90, 55, 45, 40);
        _followingStrLabel.text = @"关注";
        [_followingStrLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
    }
    return _followingStrLabel;
}

- (UILabel *)fansNumLabel{
    if (_fansNumLabel == nil) {
        _fansNumLabel = [[UILabel alloc] init];
        [_fansNumLabel setFrame:CGRectMake(kScreenWidth/2+65, 40, 25, 20)];
        _fansNumLabel.layer.cornerRadius = 2;
        _fansNumLabel.layer.masksToBounds = YES;
        _fansNumLabel.textAlignment = NSTextAlignmentCenter;
        [_fansNumLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
        _fansNumLabel.backgroundColor = [UIColor colorWithRed:182/256.0 green:71/256.0 blue:72/256.0 alpha:1];
    }
    return _fansNumLabel;
}

- (UILabel *)fansStrLabel{
    if (_fansStrLabel == nil) {
        _fansStrLabel = [[UILabel alloc] init];
        _fansStrLabel.frame = CGRectMake(kScreenWidth/2+60, 55, 45, 40);
        _fansStrLabel.text = @"粉丝";
        [_fansStrLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
    }
    return _fansStrLabel;
}

- (NSMutableArray *)myVideoArray {
    if (_myVideoArray == nil) {
        _myVideoArray = [NSMutableArray array];
    }
    return _myVideoArray;
}


- (UICollectionView *) myVideoCollectionView{
    if (_myVideoCollectionView == nil) {
        _myVideoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kMagicZero, kProfileCollectionViewY, kScreenWidth, kProfileCollectionViewHeight-CGRectGetHeight(self.topView.frame)) collectionViewLayout:self.flowLayout];
        _myVideoCollectionView.delegate = self;
        _myVideoCollectionView.dataSource = self;
        _myVideoCollectionView.backgroundColor = [UIColor colorWithRed:30/256.0 green:30/256.0 blue:30/256.0 alpha:1];
    }
    return _myVideoCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(kSnapshotWidthForProfile, kSnapshotWidthForProfile);
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _flowLayout;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *) collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myVideoArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKProfileVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    KKProfileVideoModel *videoModel = self.myVideoArray[indexPath.item];
    cell.aVideoModel = videoModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KKProfileVideoModel *videoModel = self.myVideoArray[indexPath.item];
    
    KKPlayVideoInProfileViewController *playVideoVC = [[KKPlayVideoInProfileViewController alloc] init];
    playVideoVC.profileVideoModel = videoModel;
    [self.navigationController pushViewController:playVideoVC animated:YES];
}





@end

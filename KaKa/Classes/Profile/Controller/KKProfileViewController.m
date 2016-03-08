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
#import "KKProfileVideoCell.h"
#import "KKProfileVideoModel.h"
#import "KKNetwork.h"
#import <SVProgressHUD.h>
#import "MJRefresh.h"
#import "Constants.h"

static NSString *ID = @"videoCell";

@interface KKProfileViewController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UICollectionView *myVideoCollectionView1;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *myVideoArray;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UIView *settingMyIconUIView;

@end

@implementation KKProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.settingMyIconUIView.backgroundColor = [UIColor blackColor];
    self.pageNum = 0;
    __weak typeof(self) weakSelf = self;
    self.myVideoCollectionView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum++;
        [weakSelf pullUpRefreshWithPageNum:weakSelf.pageNum];
    }];
    
    [self.myVideoCollectionView1 registerClass:[KKProfileVideoCell class] forCellWithReuseIdentifier:ID];
    
    [self.myVideoCollectionView1.mj_footer beginRefreshing];
}

- (void)pullUpRefreshWithPageNum:(NSInteger)pageNum{
    __weak typeof(self) weakSelf = self;
    
    //TODO: NSUserDefault 读一下 kid ，login success 写一下
    [[KKNetwork sharedInstance] getVideosOfTheUserWithKid:@"1" andPage:[NSString stringWithFormat:@"%ld", pageNum] andOrder:@"1" completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pullUpRefreshSuccess:responseJson WithPageNum:pageNum];
            [weakSelf.myVideoCollectionView1.mj_footer endRefreshing];
        });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
}

- (void)pullUpRefreshSuccess:(NSDictionary *)responseJson WithPageNum:(NSInteger)pageNum{
    NSArray *arr = [(NSArray *)responseJson[@"data"] mutableCopy];

    for (NSDictionary *dict in arr) {
        KKProfileVideoModel *theVideo = [KKProfileVideoModel videoWithDict:dict];
        [self.myVideoArray addObject:theVideo];
    }
    [self.myVideoCollectionView1 reloadData];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isLogin = [defaults boolForKey:@"isLog"];
    
    if (self.isLogin) {
        [self setProfileView];
#warning debuging
        NSLog(@"%@", @"is login");
        
    } else{
        KKLoginViewController *loginVC = [[KKLoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed=YES;//隐藏下面的tabbar
        
        [self.navigationController pushViewController:loginVC  animated:NO];
    }
}

- (void)setProfileView {
    
    [self setProfileCollectionView];
    
    [self setTopInformation ];
}

- (void) setProfileCollectionView {
    [self.view addSubview:self.myVideoCollectionView1];
}

- (UICollectionView *) myVideoCollectionView1 {
    if (_myVideoCollectionView1 == nil) {
        //TODO: 150 待修改
        _myVideoCollectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(kMagicZero, kProfileCollectionViewY, kScreenWidth, kProfileCollectionViewHeight) collectionViewLayout:self.flowLayout];
        _myVideoCollectionView1.delegate = self;
        _myVideoCollectionView1.dataSource = self;
        _myVideoCollectionView1.backgroundColor = [UIColor whiteColor];
    }
    return _myVideoCollectionView1;
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

- (NSMutableArray *)myVideoArray {
    if (_myVideoArray == nil) {
        _myVideoArray = [NSMutableArray array];
    }
    return _myVideoArray;
}

- (UIView *)settingMyIconUIView{
    if (_settingMyIconUIView == nil) {

        _settingMyIconUIView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + kNavgationBarHeight, kScreenWidth, kProfileTopUIViewHeight)];
        [self.view addSubview:_settingMyIconUIView];
    }
    return _settingMyIconUIView;
}


- (void) setTopInformation {
    
    // 设置 self.view 的背景图片
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"music"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    /* 分割线 */
    

    self.settingMyIconUIView.backgroundColor = [UIColor yellowColor];
    
    //icon
    //1.左边自已的头像
    UIImageView *imgIcon = [[UIImageView alloc]init];
    imgIcon.size = CGSizeMake(85, 85);
    imgIcon.center = CGPointMake(kScreenWidth / 2, 60);
    imgIcon.image = [UIImage imageNamed:@"imageIcon"];
    imgIcon.layer.cornerRadius = imgIcon.size.width / 2 ;
    imgIcon.layer.masksToBounds = YES;
    [self.settingMyIconUIView addSubview:imgIcon];

    // 2 右上角，setting Button.写到navigationItem.rightBarButtonItem中
    UIBarButtonItem *btnOptions = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(clickOptions) ];
    self.navigationItem.rightBarButtonItem = btnOptions;
    
   //4.1关注 数
    UILabel *noticeNumberLabel = [[UILabel alloc]init];
    noticeNumberLabel.frame = CGRectMake(110, 40, 60, 40);
//    numberOfInformationLabel.size = CGSizeMake(self.view.width * 0.618, 45);
//    numberOfInformationLabel.center = CGPointMake(self.view.width * 0.691, 55);
    noticeNumberLabel.text = @"32";
    [self.settingMyIconUIView addSubview:noticeNumberLabel];
    
    //4.2关注 字
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.frame = CGRectMake(110, 40, 60, 40);
    //    numberOfInformationLabel.size = CGSizeMake(self.view.width * 0.618, 45);
    //    numberOfInformationLabel.center = CGPointMake(self.view.width * 0.691, 55);
    noticeLabel.text = @"关注";
    [self.settingMyIconUIView addSubview:noticeLabel];
    
    //5.1 粉丝数.
    UILabel *fansNumberLabel = [[UILabel alloc]init];
//    numberOfInformation.size = CGSizeMake(self.view.width * 0.618, 45);
//    numberOfInformation.center = CGPointMake(self.view.width * 0.309, 55);
    fansNumberLabel.frame = CGRectMake(170, 40, 60, 40);
    fansNumberLabel.text = @" 粉丝";
    [self.settingMyIconUIView addSubview:fansNumberLabel];
    
    //6 nickName:华小咔
    UILabel *nickName = [[UILabel alloc]init];
    nickName.frame = CGRectMake(150, 90, 100, 40);
    //myVideoLabel.backgroundColor = [UIColor yellowColor];
    nickName.text = @"华小咔";
    [self.settingMyIconUIView addSubview:nickName];
}


- (void) clickOptions {

    KKOptionsTableVC *optionVc = [[KKOptionsTableVC alloc]init];
    //TODO: 如果这样，在退出这后会 push到 视频界面，且下边无法切换
    //optionVc.hidesBottomBarWhenPushed=YES;//隐藏下面的tabbar
    [self.navigationController pushViewController:optionVc animated:YES];
    
}
@end

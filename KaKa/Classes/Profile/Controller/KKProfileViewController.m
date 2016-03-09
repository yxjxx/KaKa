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
    self.pageNum = -1;
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *kid = [defaults objectForKey:@"kid"];
    [[KKNetwork sharedInstance] getVideosOfTheUserWithKid:kid andPage:[NSString stringWithFormat:@"%ld", pageNum] andOrder:@"1" completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf pullUpRefreshSuccess:responseJson WithPageNum:pageNum];
            [weakSelf.myVideoCollectionView1.mj_footer endRefreshing];
        });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
}

- (void)pullUpRefreshSuccess:(NSDictionary *)responseJson WithPageNum:(NSInteger)pageNum{
//    NSArray *arr = [(NSArray *)responseJson[@"data"] mutableCopy];
    NSArray *arr = (NSArray *)responseJson[@"data"];

    for (NSDictionary *dict in arr) {
        KKProfileVideoModel *theVideo = [KKProfileVideoModel videoWithDict:dict];
        [self.myVideoArray addObject:theVideo];
    }
    [self.myVideoCollectionView1 reloadData];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
   
#warning testing 每次重新登录，以防止上传文件失败
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isLogin = [defaults boolForKey:@"isLog"];
//    self.isLogin = nil;
    
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
        _myVideoCollectionView1.backgroundColor = [UIColor colorWithRed:30/256.0 green:30/256.0 blue:30/256.0 alpha:1];
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
//TODO: RGB取色不可以？？！！
    //self.settingMyIconUIView.backgroundColor = [UIColor colorWithRed:32 green:32 blue:32 alpha:1];
   
    self.settingMyIconUIView.backgroundColor = [UIColor colorWithRed:46/256.0 green:46/256.0 blue:46/256.0 alpha:1];
    //icon
    //1.中间 自已的头像
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
    noticeNumberLabel.frame = CGRectMake((kScreenWidth / 2) - 85, 40, 25, 20);
    
    noticeNumberLabel.text = @"32";
    noticeNumberLabel.layer.cornerRadius = 2;
    noticeNumberLabel.layer.masksToBounds = YES;
    noticeNumberLabel.textAlignment = NSTextAlignmentCenter;
    [noticeNumberLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
   noticeNumberLabel.backgroundColor = [UIColor colorWithRed:182/256.0 green:71/256.0 blue:72/256.0 alpha:1];
    [self.settingMyIconUIView addSubview:noticeNumberLabel];
    
    //4.2关注 字
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.frame = CGRectMake((kScreenWidth / 2) - 90, 55, 45, 40);
    //TODO: nslog ,kscrrenHeight:140707721448624
    //    numberOfInformationLabel.size = CGSizeMake(self.view.width * 0.618, 45);
    //    numberOfInformationLabel.center = CGPointMake(self.view.width * 0.691, 55);
    noticeLabel.text = @"关注";
   
    [noticeLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
    [self.settingMyIconUIView addSubview:noticeLabel];
    
    //5.1 粉丝数.
    UILabel *fansNumberLabel = [[UILabel alloc]init];
//    numberOfInformation.size = CGSizeMake(self.view.width * 0.618, 45);
//    numberOfInformation.center = CGPointMake(self.view.width * 0.309, 55);
    fansNumberLabel.frame = CGRectMake((kScreenWidth / 2) + 65, 40, 25, 20);
    fansNumberLabel.text = @"16";
    
    fansNumberLabel.layer.cornerRadius = 3;
    fansNumberLabel.layer.masksToBounds = YES;
    
    fansNumberLabel.textAlignment = NSTextAlignmentCenter;
    [fansNumberLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
    fansNumberLabel.backgroundColor = [UIColor colorWithRed:182/256.0 green:71/256.0 blue:72/256.0 alpha:1];
    [self.settingMyIconUIView addSubview:fansNumberLabel];
    //5.2 粉丝字.
    UILabel *fansLabel = [[UILabel alloc]init];
    //    numberOfInformation.size = CGSizeMake(self.view.width * 0.618, 45);
    //    numberOfInformation.center = CGPointMake(self.view.width * 0.309, 55);
    fansLabel.frame = CGRectMake((kScreenWidth / 2) + 60, 55, 45, 40);
    fansLabel.text = @"粉丝";
    [fansLabel setTextColor:[UIColor colorWithRed:243/256.0 green:233/256.0 blue:234/256.0 alpha:1]];
    [self.settingMyIconUIView addSubview:fansLabel];

    
    //6 nickName:华小咔
    UILabel *nickName = [[UILabel alloc]init];
    nickName.frame = CGRectMake(kScreenWidth / 2  - 30, 100, 60, 40);
    nickName.textColor = [UIColor colorWithRed:250/256.0 green:250/256.0 blue:250/256.0 alpha:1];
    nickName.text = @"华小咔";
    [self.settingMyIconUIView addSubview:nickName];
    
    //7 a black line
    UIView *blackLineUIView = [[UIView alloc]init];
    blackLineUIView.frame = CGRectMake(0, 148, 500, 2);
    blackLineUIView.backgroundColor = [UIColor blackColor ];
    
    [self.settingMyIconUIView addSubview:blackLineUIView];
}


- (void) clickOptions {

    KKOptionsTableVC *optionVc = [[KKOptionsTableVC alloc]init];
    //TODO: 如果这样，在退出这后会 push到 视频界面，且下边无法切换
    //optionVc.hidesBottomBarWhenPushed=YES;//隐藏下面的tabbar
    [self.navigationController pushViewController:optionVc animated:YES];
    
}
@end

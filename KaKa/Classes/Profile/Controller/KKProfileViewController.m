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

@end

@implementation KKProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //[self.navigationItem setHidesBackButton:NO];
//
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"logBg.jpg"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
//    
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
        _myVideoCollectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(kMagicZero, 200, kScreenWidth, kMainPageTableViewHeigh) collectionViewLayout:self.flowLayout];
        _myVideoCollectionView1.delegate = self;
        _myVideoCollectionView1.dataSource = self;
        _myVideoCollectionView1.backgroundColor = [UIColor whiteColor];
    }
    return _myVideoCollectionView1;
}


- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(kSnapshotWidth, kSnapshotWidth);
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

- (void) setTopInformation {
    
    UIView *settingMyIcon = [[UIView alloc]init];
//    settingMyIcon.size = CGSizeMake(self.view.width, 140);
//    settingMyIcon.center = CGPointMake(self.view.width / 2, 140 + kStatusBarHeight);
    settingMyIcon.frame = CGRectMake(0, kStatusBarHeight + kNavgationBarHeight, self.view.width, 150);
    [settingMyIcon showPlaceHolder];
    NSLog(@"self.view.width:%d,",self.view.width);
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"music"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
//    settingMyIcon.backgroundColor  = [UIColor yellowColor];
//    //    settingMyIcon.frame = CGRectMake(0, kStatusBarHeight * 3, self.view.width, 150);
//    [settingMyIcon setBackgroundColor:[UIColor purpleColor]]; 
//    这个宽有问题
    settingMyIcon.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:settingMyIcon];
    //icon
    //1.左边自已的头像
    UIImageView *imgIcon = [[UIImageView alloc]init];
    imgIcon.size = CGSizeMake(85, 85);
    imgIcon.center = CGPointMake(self.view.width / 2, 60);
    
  //  imgIcon.frame = CGRectMake(20, 20, 80, 80);
    //NSLog(@"settingMyIcon.frame.size.width:%d",settingMyIcon.frame.size.width );
    [imgIcon showPlaceHolder];
    imgIcon.image = [UIImage imageNamed:@"imageIcon"];
    imgIcon.layer.cornerRadius = imgIcon.size.width / 2 ;
    imgIcon.layer.masksToBounds = YES;
    [settingMyIcon addSubview:imgIcon];

    // 2 右上角，setting Button.写到navigationItem.rightBarButtonItem中
    UIBarButtonItem *btnOptions = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(clickOptions) ];
    self.navigationItem.rightBarButtonItem = btnOptions;
//    //3. nickName
//    UILabel *nickNameLabel = [[UILabel alloc]init];
//    //    numberOfInformation.size = CGSizeMake(self.view.width * 0.618, 45);
//    //    numberOfInformation.center = CGPointMake(self.view.width * 0.309, 55);
//    nickNameLabel.frame = CGRectMake(10, 100, 130, 40);
//    
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *userName = [defaults stringForKey:kUsernameKey];
//
//    nickNameLabel.text =userName;
//    [nickNameLabel showPlaceHolder];
//    [settingMyIcon addSubview:nickNameLabel];
    
   //4.1关注 数
    UILabel *noticeNumberLabel = [[UILabel alloc]init];
    noticeNumberLabel.frame = CGRectMake(110, 40, 60, 40);
//    numberOfInformationLabel.size = CGSizeMake(self.view.width * 0.618, 45);
//    numberOfInformationLabel.center = CGPointMake(self.view.width * 0.691, 55);
    noticeNumberLabel.text = @"32";
    [settingMyIcon addSubview:noticeNumberLabel];
    //4.2关注 字
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.frame = CGRectMake(110, 40, 60, 40);
    //    numberOfInformationLabel.size = CGSizeMake(self.view.width * 0.618, 45);
    //    numberOfInformationLabel.center = CGPointMake(self.view.width * 0.691, 55);
    noticeLabel.text = @"关注";
    [settingMyIcon addSubview:noticeLabel];
    
    //5.1 粉丝数.
    UILabel *fansNumberLabel = [[UILabel alloc]init];
//    numberOfInformation.size = CGSizeMake(self.view.width * 0.618, 45);
//    numberOfInformation.center = CGPointMake(self.view.width * 0.309, 55);
    fansNumberLabel.frame = CGRectMake(170, 40, 60, 40);
    fansNumberLabel.text = @" 粉丝";
    [settingMyIcon addSubview:fansNumberLabel];
    
    //6 nickName:华小咔
    UILabel *nickName = [[UILabel alloc]init];
    nickName.frame = CGRectMake(150, 90, 100, 40);
    //myVideoLabel.backgroundColor = [UIColor yellowColor];
    nickName.text = @"华小咔";
    [settingMyIcon addSubview:nickName];

}


- (void) clickOptions {

    KKOptionsTableVC *optionVc = [[KKOptionsTableVC alloc]init];
    //TODO: 如果这样，在退出这后会 push到 视频界面，且下边无法切换
    //optionVc.hidesBottomBarWhenPushed=YES;//隐藏下面的tabbar
    [self.navigationController pushViewController:optionVc animated:YES];
    
}
@end

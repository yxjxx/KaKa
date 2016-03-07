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
#import "Constants.h"
#import "KKProfileVideoCell.h"
#import "KKProfileVideoModel.h"

static NSString *ID = @"videoCell";

@interface KKProfileViewController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UICollectionView *myVideoCollectionView1;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *myVideoArray;


@end

@implementation KKProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //[self.navigationItem setHidesBackButton:NO];

    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"logBg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
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
        _myVideoCollectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth, 150, kScreenWidth, kMainPageTableViewHeigh) collectionViewLayout:self.flowLayout];
        _myVideoCollectionView1.delegate = self;
        _myVideoCollectionView1.dataSource = self;
        _myVideoCollectionView1.backgroundColor = [UIColor yellowColor];
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
    settingMyIcon.size = CGSizeMake(self.view.width, 140);
    settingMyIcon.center = CGPointMake(kScreenWidth / 2, 130 + kStatusBarHeight);
    settingMyIcon.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:settingMyIcon];
    //icon
   
    //nickName
    UILabel *lblNickName = [[UILabel alloc]init];
    lblNickName.size = CGSizeMake(260, 40);
    lblNickName.center = CGPointMake(self.view.width / 2, 40);
    //这里传入nickName的参数
    lblNickName.text = @"welcome, here is your nick name";
    [settingMyIcon addSubview:lblNickName];
    
    // 右上角，setting Button.写到navigationItem.rightBarButtonItem中
    self.view.backgroundColor = [UIColor purpleColor];
    UIBarButtonItem *btnOptions = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(clickOptions) ];
    self.navigationItem.rightBarButtonItem = btnOptions;
   
    UILabel *lblNumbersOfFollowings = [[UILabel alloc]init];
    lblNumbersOfFollowings.size = CGSizeMake(260, 30);
    lblNumbersOfFollowings.center = CGPointMake(self.view.width / 2 + 30, 70);
    lblNumbersOfFollowings.text = @"posts:   followers:  following:";
    
    [settingMyIcon addSubview:lblNumbersOfFollowings];
    //posts ,follows
    UITextField *text1post = [[UITextField alloc]init];
    UITextField *text2followers = [[UITextField alloc]init];
    UITextField *text3following = [[UITextField alloc]init];
    text1post.size = CGSizeMake(80, 30);
    text2followers.size = CGSizeMake(80, 30);
    text3following.size = CGSizeMake(80, 30);
    text1post.center = CGPointMake(150, 100);
    text2followers.center = CGPointMake(230, 100);
    text3following.center = CGPointMake(300, 100);
    text1post.text = @"5";
    text2followers.text = @"9";
    text3following.text = @"0";
    [settingMyIcon addSubview:text1post];
    [settingMyIcon addSubview:text2followers];
    [settingMyIcon addSubview:text3following];
    
    
}


- (void) clickOptions {

    KKOptionsTableVC *optionVc = [[KKOptionsTableVC alloc]init];
    [self.navigationController pushViewController:optionVc animated:YES];
    
}
@end

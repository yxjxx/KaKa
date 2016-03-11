//
//  KKUploadVideoViewController.m
//  KaKa
//
//  Created by yxj on 3/7/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKUploadVideoViewController.h"
#import "KRVideoPlayerControlView.h"
#import "KKNetwork.h"
#import "AppDelegate.h"
#import "KKLocalVideoCell.h"
#import <SVProgressHUD.h>

static NSString *ID = @"localVideoCell";

@interface KKUploadVideoViewController() <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) KRVideoPlayerController *videoPreviewController;
@property (nonatomic, strong) KRVideoPlayerControlView *videoControlView;
@property (nonatomic, strong) UITextField *videoDescTextFiled;
@property (nonatomic, strong) UIButton *giveupUploadButton;
@property (nonatomic, strong) UIButton *startUploadButton;
@property (nonatomic, strong) NSArray *allLocalVideosArray;
@property (nonatomic, strong) UICollectionView *allLocalVideoCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) KKVideoRecordModel *selectedLocalVideo;

@end

@implementation KKUploadVideoViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
#warning testing
    //TODO: color adjust
    self.view.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.videoDescTextFiled];
    
    [self.giveupUploadButton addTarget:self action:@selector(clickGiveUpBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.startUploadButton addTarget:self action:@selector(clickStartUploadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.allLocalVideoCollectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.videoPreviewController setDimissCompleteBlock:^{
        [weakSelf.videoPreviewController pause];
        weakSelf.videoPreviewController = nil;
    }];

    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.video_library_data){
        //TODO: 处理数组为空的异常
        self.selectedLocalVideo = [appDelegate.video_library_data lastObject];
        
        // 这一行代码 This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release.
        //    [self playLocalVideo:self.selectedLocalVideo];
        //解决办法
        NSString *vPathStr = [[kDocumentsPath stringByAppendingPathComponent:VIDEO_PATH] stringByAppendingPathComponent:self.selectedLocalVideo.path];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playVideoWithURL:[NSURL fileURLWithPath:vPathStr]];
            [weakSelf.view addSubview:weakSelf.videoPreviewController.view];
        });
//        [self playVideoWithURL:[NSURL fileURLWithPath:vPathStr]];
    }
    
    //add videoPreviewController.view 必须在 showinwindow 之后
//    [self.view addSubview:self.videoPreviewController.view];
    [self.allLocalVideoCollectionView registerClass:[KKLocalVideoCell class] forCellWithReuseIdentifier:ID];

}

- (KKVideoRecordModel *)selectedLocalVideo{
    if (_selectedLocalVideo == nil) {
        _selectedLocalVideo = [[KKVideoRecordModel alloc] init];
    }
    return _selectedLocalVideo;
}


- (void)clickGiveUpBtn{
    //TODO: 放弃上传
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickStartUploadBtn{
    if ([self.videoDescTextFiled.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"为你的视频取一个名字吧...（必填）"];
        return;
    } else{
        //每次上传视频之前先发一个登录请求到服务端
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *mobile = [defaults objectForKey:@"mobile"];
        NSString *passwordMD5 = [defaults objectForKey:@"passwordMD5"];
        
        [[KKNetwork sharedInstance] loginWithMobile:mobile andPasswordMD5:passwordMD5 completeSuccessed:^(NSDictionary *responseJson) {
            NSLog(@"%@", responseJson);
            if ([(NSNumber *)responseJson[@"errcode"] intValue] == 0) {
                NSLog(@"登录成功");
//                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            } else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"登录失败"]];
                return;
            }
        } completeFailed:^(NSString *failedStr) {
            NSLog(@"failed, %@", failedStr);
        }];
        
        self.selectedLocalVideo.name = self.videoDescTextFiled.text;
    }
    [SVProgressHUD showWithStatus:@"开始上传视频"];
    [[KKNetwork sharedInstance] uploadVideoWithAKKVideoRecordModel:self.selectedLocalVideo completeSuccessed:^(NSDictionary *responseJson) {
        NSLog(@"Upload Success: %@", responseJson);
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *msg = responseJson[@"errmsg"];
            //TODO: 通过 errorcode 来判断失败类型
            if ([(NSNumber *)responseJson[@"errcode"] intValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            } else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"上传失败, 未登录"]];
            }
        });
    } completeFailed:^(NSString *failedStr) {
        NSLog(@"video upload failed %@", failedStr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"uploading failed"];
        });
    }];
}

- (NSArray *)allLocalVideosArray{
    if (_allLocalVideosArray == nil) {
        _allLocalVideosArray = [[NSArray alloc] init];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if(appDelegate.video_library_data){
            _allLocalVideosArray = appDelegate.video_library_data;
        } else{
            return nil;
        }
    }
    return _allLocalVideosArray;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(kSnapshotWidthForProfile, kSnapshotWidthForProfile);
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _flowLayout;
}

- (UICollectionView *)allLocalVideoCollectionView{
    if (_allLocalVideoCollectionView == nil) {
        _allLocalVideoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.videoDescTextFiled.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.videoDescTextFiled.frame) ) collectionViewLayout:self.flowLayout];
        _allLocalVideoCollectionView.delegate = self;
        _allLocalVideoCollectionView.dataSource = self;
        _allLocalVideoCollectionView.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
    }
    return _allLocalVideoCollectionView;
}


- (UIButton *)giveupUploadButton{
    if (_giveupUploadButton == nil) {
        //TODO: frame adjust
        _giveupUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
        [_giveupUploadButton setTitle:@"取消" forState:UIControlStateNormal];
        [_giveupUploadButton sizeToFit];
        [self.view addSubview:_giveupUploadButton];
    }
    return _giveupUploadButton;
}

- (UIButton *)startUploadButton{
    if (_startUploadButton == nil) {
        //TODO: frame adjust
        _startUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 79, 5, 64, 32)];
        [_startUploadButton setTitle:@"开始上传" forState:UIControlStateNormal];
        [_startUploadButton sizeToFit];
        [self.view addSubview:_startUploadButton];
    }
    return _startUploadButton;
}

- (KRVideoPlayerController *)videoPreviewController{
    if (_videoPreviewController == nil) {
        _videoPreviewController = [[KRVideoPlayerController alloc] init];
        [_videoPreviewController setFrame:CGRectMake(0, kNavgationBarHeight, kScreenWidth, kScreenWidth)];
    }
    return _videoPreviewController;
}

- (UITextField *)videoDescTextFiled{
    if (_videoDescTextFiled == nil) {
        _videoDescTextFiled = [[UITextField alloc] init];
        [_videoDescTextFiled setFrame:CGRectMake(0, CGRectGetMaxY(self.videoPreviewController.view.frame), kScreenWidth, 40)];
        _videoDescTextFiled.placeholder = @"为你的视频取一个名字吧...（必填）";
        _videoDescTextFiled.returnKeyType = UIReturnKeyDone;
        _videoDescTextFiled.clearButtonMode = UITextFieldViewModeAlways;
        _videoDescTextFiled.keyboardAppearance = UIKeyboardAppearanceDark;
        _videoDescTextFiled.delegate = self;
        // change placeholder text color
        _videoDescTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_videoDescTextFiled.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1]}];

        _videoDescTextFiled.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
    }
    return _videoDescTextFiled;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.videoDescTextFiled resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)playVideoWithURL:(NSURL *)url
{
    self.videoPreviewController.contentURL = url;
    [self.videoPreviewController showInWindow];
}

- (void)viewWillDisappear:(BOOL)animated{
    //    NSLog(@"%s", __func__);
    // 切换控制器的时候，dismiss 掉 videoController
    [self.videoPreviewController pause];
//    [self.videoPreviewController dismiss];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allLocalVideosArray.count;
}

- (KKLocalVideoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKLocalVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    // 把 uicollectionviewcell 逆序显示
    KKVideoRecordModel *videoModel = self.allLocalVideosArray[self.allLocalVideosArray.count-indexPath.item-1];
//    KKVideoRecordModel *videoModel = self.allLocalVideosArray[indexPath.item];
    cell.aVideoModel = videoModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedLocalVideo = self.allLocalVideosArray[self.allLocalVideosArray.count-indexPath.item-1];
    
    [self playLocalVideo:self.selectedLocalVideo];
}

- (void)playLocalVideo:(KKVideoRecordModel *)selectedLocalVideo{
    NSString *vPathStr = [[kDocumentsPath stringByAppendingPathComponent:VIDEO_PATH] stringByAppendingPathComponent:selectedLocalVideo.path];
    self.videoPreviewController.contentURL = [NSURL fileURLWithPath:vPathStr];
}

@end

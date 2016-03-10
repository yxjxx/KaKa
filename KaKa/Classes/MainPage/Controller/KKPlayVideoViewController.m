//
//  KKPlayVideoViewController.m
//  KaKa
//
//  Created by yxj on 3/1/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKPlayVideoViewController.h"
#import "KRVideoPlayerController.h"
#import "KKPlayVideoVCBottomView.h"

@interface KKPlayVideoViewController()

@property (nonatomic, strong) KRVideoPlayerController *videoController;

@property (nonatomic, strong) KKPlayVideoVCBottomView *bottomView;

@end


@implementation KKPlayVideoViewController

- (KKPlayVideoVCBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[KKPlayVideoVCBottomView alloc] init];
//        _bottomView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    return _bottomView;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.bottomView];
#warning 临时图
    
    self.view.backgroundColor = [UIColor colorWithRed:46/256.0 green:46/246.0 blue:46/256.0 alpha:1];
    UIView *tempory = [[UIView alloc]init];
    tempory.frame = CGRectMake(0, kScreenHeight - 230, 450, 230);
    tempory.backgroundColor = [UIColor grayColor];
    [self.view addSubview:tempory];
    
    UILabel *UpNameLbl = [[UILabel alloc]init];
    UpNameLbl.frame = CGRectMake(10, 30, 200, 35);
    UpNameLbl.text = @"播主：李大咔";
    
    UpNameLbl.textColor = [UIColor blackColor];
    [tempory addSubview:UpNameLbl];
    
    UILabel *UpTimeLbl = [[UILabel alloc]init];
    UpTimeLbl.frame = CGRectMake(10, 110, 290, 35);
    UpTimeLbl.textColor = [UIColor blackColor];
    UpTimeLbl.text = @"上传时间：2016年3月9日 16:56";
    [tempory addSubview:UpTimeLbl];
    
    
    //TODO:  delete this above
    /*  temportary  */
    self.title = self.videoModel.videoVName;
    
    __weak typeof(self)weakSelf = self;
    [self.videoController setDimissCompleteBlock:^{
        [weakSelf.videoController pause];
        weakSelf.videoController = nil;
        // NavigationController pop when _videoController dismiss
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
//    NSURL *videoURL = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
//    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"hehe" withExtension:@"mov"];

    
    NSURL *videoFullPath = [NSURL URLWithString: self.videoModel.videoPath];
//    NSURL *videoFullPath = [[NSBundle mainBundle] URLForResource:@"hehe" withExtension:@"mov"];
    
    [self playVideoWithURL:videoFullPath];
}

- (KRVideoPlayerController *)videoController{
    if (_videoController == nil) {
        _videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavgationBarHeight, kScreenWidth, kScreenWidth)];
    }
    return _videoController;
}


- (void)playVideoWithURL:(NSURL *)url
{
    self.videoController.contentURL = url;
    [self.videoController showInWindow];
}

- (void)viewWillDisappear:(BOOL)animated{
//    NSLog(@"%s", __func__);
    // 切换控制器的时候，dismiss 掉 videoController
    [self.videoController pause];
    [self.videoController dismiss];
}


@end

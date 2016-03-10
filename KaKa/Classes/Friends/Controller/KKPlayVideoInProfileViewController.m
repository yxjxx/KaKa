//
//  KKPlayVideoInProfileViewController.m
//  KaKa
//
//  Created by yxj on 3/10/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKPlayVideoInProfileViewController.h"
#import "KRVideoPlayerController.h"

@interface KKPlayVideoInProfileViewController()

@property (nonatomic, strong) KRVideoPlayerController *videoController;

@end

@implementation KKPlayVideoInProfileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.title = self.profileVideoModel.videoName;
    
    __weak typeof(self)weakSelf = self;
    [self.videoController setDimissCompleteBlock:^{
        [weakSelf.videoController pause];
        weakSelf.videoController = nil;
        // NavigationController pop when _videoController dismiss
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    //    NSURL *videoURL = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
    //    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"hehe" withExtension:@"mov"];
    
    
    NSURL *videoFullPath = [NSURL URLWithString: self.profileVideoModel.videoPath];
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

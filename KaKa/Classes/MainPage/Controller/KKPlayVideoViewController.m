//
//  KKPlayVideoViewController.m
//  KaKa
//
//  Created by yxj on 3/1/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKPlayVideoViewController.h"
#import "KRVideoPlayerController.h"

@interface KKPlayVideoViewController()

@property (nonatomic, strong) KRVideoPlayerController *videoController;

@end


@implementation KKPlayVideoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
//    NSURL *videoURL = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"hehe" withExtension:@"mov"];
//    NSLog(@"%@", videoURL);

    [self playVideoWithURL:videoURL];
}

- (KRVideoPlayerController *)videoController{
    if (_videoController == nil) {
        _videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            [weakSelf.videoController pause];
            weakSelf.videoController = nil;
            // NavigationController pop when _videoController dismiss
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

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
    [self.videoController dismiss];
}


@end

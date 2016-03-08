//
//  KKUploadVideoViewController.m
//  KaKa
//
//  Created by yxj on 3/7/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKUploadVideoViewController.h"
#import "KRVideoPlayerControlView.h"
#import "Masonry.h"
#import "KKNetwork.h"
#import "AppDelegate.h"

@interface KKUploadVideoViewController()

@property (nonatomic, strong) KRVideoPlayerController *videoPreviewController;
@property (nonatomic, strong) KRVideoPlayerControlView *videoControlView;
@property (nonatomic, strong) UITextField *videoDescTextFiled;

@end

@implementation KKUploadVideoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
#warning testing
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.videoPreviewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.equalTo(self.view.width);
//        make.top.equalTo(self.view);
//        make.left.equalTo(self.view);
//    }];
//    NSLog(@"%@", self.videoPreviewController.view);
    
    __weak typeof(self)weakSelf = self;
    [self.videoPreviewController setDimissCompleteBlock:^{
        [weakSelf.videoPreviewController pause];
        weakSelf.videoPreviewController = nil;
        // NavigationController pop when _videoController dismiss
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
//    [self.videoPreviewController.videoControl setFullscreen:NO];
    
//    NSURL *videoFullPath = [[NSBundle mainBundle] URLForResource:@"hehe" withExtension:@"mov"];
    KKVideoRecordModel *aKKVideoRecordModel = [[KKVideoRecordModel alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.video_library_data){
        aKKVideoRecordModel = [appDelegate.video_library_data lastObject];
    }
    NSString *mystr = [[kDocumentsPath stringByAppendingPathComponent:@"video"] stringByAppendingPathComponent:[aKKVideoRecordModel.path lastPathComponent]];
    NSLog(@"current_documents%@", mystr);
    NSURL *videoFullPath = [NSURL fileURLWithPath:mystr];
    NSLog(@"stored_%@", videoFullPath);
    [self playVideoWithURL:videoFullPath];
    
    //  所以在 mas_makeConstraints block 中用到了的控件都必须添加到 superview 上
    [self.view addSubview:self.videoPreviewController.view];
    [self.view addSubview:self.videoDescTextFiled];
    NSLog(@"%@", self.videoDescTextFiled.superview);
    
    [self.videoDescTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoPreviewController.view.bottom).with.offset(5);
        make.left.equalTo(self.view.left).with.offset(10);
        make.width.equalTo(self.view.width).with.offset(10);
        make.height.equalTo(@30);
    }];
    
//    [self uploadVideo];

}

#warning testing 
//TODO: 第2次上传报错
- (void)uploadVideo{
    KKVideoRecordModel *aKKVideoRecordModel = [[KKVideoRecordModel alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.video_library_data){
        aKKVideoRecordModel = [appDelegate.video_library_data lastObject];
    }
    
    [[KKNetwork sharedInstance] uploadVideoWithAKKVideoRecordModel:aKKVideoRecordModel completeSuccessed:^(NSDictionary *responseJson) {
        NSLog(@"Upload Success: %@", responseJson);
    } completeFailed:^(NSString *failedStr) {
        NSLog(@"video upload failed %@", failedStr);
    }];
}

- (KRVideoPlayerController *)videoPreviewController{
    if (_videoPreviewController == nil) {
        _videoPreviewController = [[KRVideoPlayerController alloc] init];
        [_videoPreviewController setFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    }
    return _videoPreviewController;
}

- (UITextField *)videoDescTextFiled{
    if (_videoDescTextFiled == nil) {
        _videoDescTextFiled = [[UITextField alloc] init];
        _videoDescTextFiled.placeholder = @"为你的视频取一个名字吧...";
    }
    return _videoDescTextFiled;
}


- (void)playVideoWithURL:(NSURL *)url
{
    self.videoPreviewController.contentURL = url;
    [self.videoPreviewController showInWindow];
}

- (void)viewWillDisappear:(BOOL)animated{
    //    NSLog(@"%s", __func__);
    // 切换控制器的时候，dismiss 掉 videoController
//    [self.videoPreviewController pause];
//    [self.videoPreviewController dismiss];
}



@end

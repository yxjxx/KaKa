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

@interface KKUploadVideoViewController() <UITextFieldDelegate>

@property (nonatomic, strong) KRVideoPlayerController *videoPreviewController;
@property (nonatomic, strong) KRVideoPlayerControlView *videoControlView;
@property (nonatomic, strong) UITextField *videoDescTextFiled;
@property (nonatomic, strong) UIButton *giveupUploadButton;
@property (nonatomic, strong) UIButton *startUploadButton;

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
    
    __weak typeof(self)weakSelf = self;
    [self.videoPreviewController setDimissCompleteBlock:^{
        [weakSelf.videoPreviewController pause];
        weakSelf.videoPreviewController = nil;
        // NavigationController pop when _videoController dismiss
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
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
    
    [self.view addSubview:self.videoPreviewController.view];
    [self.view addSubview:self.videoDescTextFiled];
    
//TODO: upload video
//    [self uploadVideo];
    [self.giveupUploadButton sizeToFit];
    [self.startUploadButton sizeToFit];
    [self.giveupUploadButton addTarget:self action:@selector(clickGiveUpBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.startUploadButton addTarget:self action:@selector(clickStartUploadBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickGiveUpBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickStartUploadBtn{
    NSLog(@"%s", __func__);
}


- (UIButton *)giveupUploadButton{
    if (_giveupUploadButton == nil) {
        //TODO: frame adjust
        _giveupUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
        [_giveupUploadButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.view addSubview:_giveupUploadButton];
    }
    return _giveupUploadButton;
}

- (UIButton *)startUploadButton{
    if (_startUploadButton == nil) {
        //TODO: frame adjust
        _startUploadButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 79, 5, 64, 32)];
        [_startUploadButton setTitle:@"开始上传" forState:UIControlStateNormal];
        [self.view addSubview:_startUploadButton];
    }
    return _startUploadButton;
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
        [_videoPreviewController setFrame:CGRectMake(0, kNavgationBarHeight, kScreenWidth, kScreenWidth)];
    }
    return _videoPreviewController;
}

- (UITextField *)videoDescTextFiled{
    if (_videoDescTextFiled == nil) {
        _videoDescTextFiled = [[UITextField alloc] init];
        [_videoDescTextFiled setFrame:CGRectMake(5, CGRectGetMaxY(self.videoPreviewController.view.frame), kScreenWidth-10, 30)];
        _videoDescTextFiled.placeholder = @"为你的视频取一个名字吧...";
        _videoDescTextFiled.returnKeyType = UIReturnKeyDone;
        _videoDescTextFiled.clearButtonMode = UITextFieldViewModeAlways;
        _videoDescTextFiled.keyboardAppearance = UIKeyboardAppearanceDark;
        _videoDescTextFiled.delegate = self;
        _videoDescTextFiled.backgroundColor = [UIColor whiteColor];
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
//    [self.videoPreviewController pause];
//    [self.videoPreviewController dismiss];
}



@end

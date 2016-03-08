//
//  KKCameraViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKCameraViewController.h"
#import "KKSoundLibraryScrollView.h"
#import "KKAudioRecordModel.h"
#import "KKVideoRecordModel.h"
#import "AppDelegate.h"

@import AVFoundation;

typedef void (^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface KKCameraViewController () <AVCaptureFileOutputRecordingDelegate, AVAudioPlayerDelegate, KKSoundLibraryScrollDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet KKSoundLibraryScrollView *scrollView;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
@property (strong, nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong, nonatomic) AVCaptureDeviceInput *videoCaptureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong, nonatomic) AVCaptureDeviceInput *audioCaptureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong, nonatomic) AVCaptureMovieFileOutput *caputureMovieFileOutput;//输出数据
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (strong, nonatomic) KKAudioRecordModel * audio_model;
@property (strong, nonatomic) NSString * tempRecordPath;
@property (strong, nonatomic) NSString * cmpsRecordPath;
@property (strong, nonatomic) NSString * snapshotPath;
@property (unsafe_unretained, nonatomic) BOOL canRecord;
@end


@implementation KKCameraViewController


- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)closeView:(id)sender {
    // 显示Tabbar
    if(self.tempRecordPath){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"视频尚未保存, 是否离开" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self saveVideo: self];
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    self.tabBarController.tabBar.hidden=NO;
//   [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveVideo:(id)sender {
    if(self.tempRecordPath){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSString *audio_path = [appDelegate.audio_dir stringByAppendingPathComponent:self.audio_model.path];
        [self compoundVideoWithApath: audio_path WithVpath:self.tempRecordPath];
    }
}


/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // 隐藏Tabbar
    self.tabBarController.tabBar.hidden=YES;
    _scrollView.delegate = self;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSInteger count = appDelegate.audio_library_data.count;
    for(int i=0; i<count; ++i){
        /*
        KKAudioRecordModel *arm =
        [[KKAudioRecordModel alloc]init];
        arm.subject = @"甄嬛传";
        arm.path = @"008f828477b88a33bc8ce71625b352f3.mp3";
        arm.aid = i;
        
        appDelegate.audio_library_data[i] = arm;
        */
        [self.scrollView addItemWithModel: appDelegate.audio_library_data[i]];
    }
    /*
    BOOL ret = [NSKeyedArchiver archiveRootObject:appDelegate.audio_library_data toFile:appDelegate.audio_library];
    
    NSAssert(ret,@"写入本地视频库失败 : %@", appDelegate.audio_library);
    */
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.canRecord = NO;
    
    self.tempRecordPath = nil;
    // 初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    /*
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        // 设置会话的 sessionPreset 属性, 这个属性影响视频的分辨率
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    */
    // 获得输入设备
    AVCaptureDevice *videoCaptureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];//取得后置摄像头
    if (!videoCaptureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    /*
    // 添加一个音频输入设备
    // 直接可以拿数组中的数组中的第一个
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    */
    NSError *error=nil;
    
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:videoCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，------ %@",error.localizedDescription);
        return;
    }
    /*
    //  音频输入对象
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错 ------ %@",error);
        return;
    }
    */
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoCaptureDeviceInput]) {
        [_captureSession addInput:_videoCaptureDeviceInput];
    }
    /*
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_audioCaptureDeviceInput]) {
        [_captureSession addInput:_audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection = [_caputureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        // 标识视频录入时稳定音频流的接受，我们这里设置为自动
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    */
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _caputureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_caputureMovieFileOutput]) {
        [_captureSession addOutput:_caputureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];

    // 显示在视图表面的图层
    CALayer *layer = self.imageView.layer;
    layer.masksToBounds = true;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.masksToBounds = true;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    
    [self addNotificationToCaptureDevice:videoCaptureDevice];
    
    AVCaptureConnection *captureConnection=[self.caputureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    // 开启视频防抖模式
    AVCaptureVideoStabilizationMode stabilizationMode = AVCaptureVideoStabilizationModeCinematic;
    if ([self.videoCaptureDeviceInput.device.activeFormat isVideoStabilizationModeSupported:stabilizationMode]) {
        [captureConnection setPreferredVideoStabilizationMode:stabilizationMode];
    }
    
    // 预览图层和视频方向保持一致,这个属性设置很重要，如果不设置，那么出来的视频图像可以是倒向左边的。
    captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
    
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.caputureMovieFileOutput stopRecording];
    [self.captureSession stopRunning];
    self.canRecord = YES;
}

- (void)clickSoundLibraryItem:(id)sender{
    self.canRecord = YES;
    
    KKSoundLibraryScrollView *slsv = (KKSoundLibraryScrollView *)sender;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // 选择音频
    self.audio_model = slsv.selectedItem.model;
    
    NSString *audio_path = [appDelegate.audio_dir stringByAppendingPathComponent:self.audio_model.path];
    NSURL *url=[NSURL fileURLWithPath: audio_path];
    NSError *error=nil;
    //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    //设置播放器属性
    self.audioPlayer.numberOfLoops=0;//设置为0不循环
    self.audioPlayer.volume = 1.0; // 音量
    self.audioPlayer.delegate=self;
    [self.audioPlayer prepareToPlay];//加载音频文件到缓存
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSLog(@"%@", ((KKSoundLibraryScrollView *)sender).selectedItem.model.path);
}

- (IBAction)selectAudio:(id)sender {
    [self closeView: self];
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)startRecord:(id)sender {
    if(!self.canRecord){
        NSLog(@"未初始化");
        return;
    }
    
    if([self.caputureMovieFileOutput isRecording]){
        NSLog(@"不能中断");
        return;
    }
        
    [self.recordButton setSelected:![self.recordButton isSelected]];
    
    if ([(UIButton *)sender isSelected]) {
        // 设置视频输出的文件路径，这里设置为 temp 文件
        if(nil==_tempRecordPath){
            NSString *outputFilePath=[NSTemporaryDirectory() stringByAppendingPathComponent:[self timestamp: nil]];
            _tempRecordPath = [outputFilePath stringByAppendingString:@".mov"];
            NSLog(@"视频输出的文件路径: %@", self.tempRecordPath);
            
        }
        
        // 路径转换成 URL 要用这个方法，用 NSBundle 方法转换成 URL 的话可能会出现读取不到路径的错误
        
        NSURL *tempRecordURL = [NSURL fileURLWithPath: _tempRecordPath];
        // [self.captureSession startRunning];
        [self.caputureMovieFileOutput startRecordingToOutputFileURL:tempRecordURL recordingDelegate:self];
        [self.audioPlayer play];
        
        
    } else {
        // 暂停视频拍摄
        [self.caputureMovieFileOutput stopRecording];
        [self.captureSession stopRunning];
        
        [self.audioPlayer pause];
    }
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(flag){
        NSLog(@"音乐播放完成...");        
    }else{
        NSLog(@"音乐播放失败...");
    }
    
    [self.caputureMovieFileOutput stopRecording];
    [self.captureSession stopRunning];
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.videoCaptureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

#pragma mark 切换前后摄像头
- (IBAction)toggleCamera:(UIButton *)sender {
    AVCaptureDevice *currentDevice=[self.videoCaptureDeviceInput device];
    
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.videoCaptureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.videoCaptureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}

#pragma mark 通知

/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter     defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}

/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}

/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    // NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"---- 开始录制 ----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"---- 录制结束 ----");
    NSLog(@"错误描述: %@", error.localizedDescription);
    
    [self.recordButton setSelected:NO];
    self.canRecord = YES;
}

- (CGFloat)getfileSize:(NSString *)path{
    NSLog(@"getfileSize: %@", path);
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog (@"file size: %fM", (CGFloat)[outputFileAttributes fileSize]/1024.00/1024.00);
    return (CGFloat)[outputFileAttributes fileSize];
}

-(NSString *)timestamp:(NSDate *)date{
    if(!date){
        date = [NSDate dateWithTimeIntervalSinceNow:0];
    }
    
    NSTimeInterval ti=[date timeIntervalSince1970];
    
    NSString *tss = [NSString stringWithFormat:@"%0.f", ti];
    
    return tss;
}

// 合成视频
- (void)compoundVideoWithApath: (NSString *)apath WithVpath:(NSString *) vpath{
    NSURL *audioUrl = [NSURL fileURLWithPath:apath];
    
    NSURL *videoUrl = [NSURL fileURLWithPath:vpath];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionCommentaryTrack
        insertTimeRange: CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
        atTime:kCMTimeZero
        error:nil];
    
    AVMutableCompositionTrack * compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionVideoTrack
     insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
     ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
     atTime:kCMTimeZero
     error:nil];
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
        presetName:AVAssetExportPresetHighestQuality];
    
    AVMutableVideoCompositionLayerInstruction *mutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    
    // 变换
    CGFloat rate = 480.0/compositionVideoTrack.naturalSize.height;
    
    CGAffineTransform layerTransform = CGAffineTransformMake(compositionVideoTrack.preferredTransform.a, compositionVideoTrack.preferredTransform.b, compositionVideoTrack.preferredTransform.c, compositionVideoTrack.preferredTransform.d, compositionVideoTrack.preferredTransform.tx, compositionVideoTrack.preferredTransform.ty);
    
    
    layerTransform = CGAffineTransformRotate(layerTransform, M_PI_2);
    
    
    layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, compositionVideoTrack.naturalSize.height * rate, -(compositionVideoTrack.naturalSize.width-compositionVideoTrack.naturalSize.height) * rate / 2));//向上移动取中部影响
    
    //放缩
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
    
    [mutableVideoCompositionLayerInstruction setTransform:layerTransform atTime:kCMTimeZero];
    
    
    AVMutableVideoCompositionInstruction *mutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    [mutableVideoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)];
    
    mutableVideoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:mutableVideoCompositionLayerInstruction];
    
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    
    mutableVideoComposition.instructions = [NSArray arrayWithObject:mutableVideoCompositionInstruction];
    
    mutableVideoComposition.renderSize = CGSizeMake(480.0f, 480.0f);
    
    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    [_assetExport setVideoComposition:mutableVideoComposition];
    
    // 设置导出文件的存放路径
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // 生成文件名
    self.tempRecordPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"cmpd-%@.mov",[formatter stringFromDate:date]]];
    
    NSURL *exportUrl = [NSURL fileURLWithPath:self.tempRecordPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.tempRecordPath]){
        [[NSFileManager defaultManager] removeItemAtPath:self.tempRecordPath error:nil];
    }
    
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
        switch(_assetExport.status){
            case AVAssetExportSessionStatusFailed:
                NSLog(@"cmpd exporting failed %@",[_assetExport error]);
                self.tempRecordPath = nil;
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"cmpd exporting completed");
                
                // 根据视频的URL创建AVURLAsset
                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:_assetExport.outputURL options:nil];
                
                // 根据AVURLAsset创建AVAssetImageGenerator对象
                
                AVAssetImageGenerator* gen = [[AVAssetImageGenerator alloc] initWithAsset: asset];
                
                gen.appliesPreferredTrackTransform = YES;
                
                // 定义获取0帧处的视频截图
                CMTime time = CMTimeMake(0, 30);
                NSError *error = nil;
                CMTime actualTime;
                
                // 获取time处的视频截图
                CGImageRef  image = [gen  copyCGImageAtTime: time actualTime: &actualTime error:&error];
                
                // 将CGImageRef转换为UIImage
                UIImage *thumbnail = [[UIImage alloc] initWithCGImage: image];
                
                NSData *imagedata =UIImagePNGRepresentation(thumbnail);
                
                self.snapshotPath = [NSString stringWithFormat:@"sp-%@.png",[formatter stringFromDate:date]];
                [imagedata writeToFile:[appDelegate.snapshot_dir stringByAppendingPathComponent:self.snapshotPath] atomically:YES];
                
                // 压缩
                [self compressVideoWithVpath: self.tempRecordPath];
                
                self.tempRecordPath = nil;
            }
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"cmpd export cancelled");
                self.tempRecordPath = nil;
                break;
            default:
                NSLog(@"cmpd default");
                self.tempRecordPath = nil;
                break;
        }
    }];
}


// 压缩视频
- (void)compressVideoWithVpath:(NSString *)vpath{
    
    NSURL *tempRecordUrl=[NSURL fileURLWithPath: vpath];
    
    // 通过文件的 url 获取到这个文件的资源
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:tempRecordUrl options:nil];
    // 用 AVAssetExportSession 这个类来导出资源中的属性
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 压缩视频
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        // 导出属性是否包含低分辨率
        // 通过资源（AVURLAsset）来定义 AVAssetExportSession，得到资源属性来重新打包资源 （AVURLAsset, 将某一些属性重新定义
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        // 设置导出文件的存放路径
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSDate    *date = [[NSDate alloc] init];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSString *outPutPath = [NSString stringWithFormat:@"cmps-%@.mp4",[formatter stringFromDate:date]];
        
        self.cmpsRecordPath = outPutPath;
        NSLog(@"cmpsRecordPath : %@", self.cmpsRecordPath);
        exportSession.outputURL = [NSURL fileURLWithPath:self.cmpsRecordPath];
        
        // 是否对网络进行优化
        exportSession.shouldOptimizeForNetworkUse = true;
        
        // 转换成MP4格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        // 开始导出,导出后执行完成的block
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch(exportSession.status){
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"cmps exporting failed %@",[exportSession error]);
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"cmps exporting completed");
                    NSInteger count = appDelegate.video_library_data.count;
                    KKVideoRecordModel *vrm = [[KKVideoRecordModel alloc]init];
                    vrm.aid = self.audio_model.aid;
                    vrm.name = @"";
                    vrm.path = self.cmpsRecordPath;
                    vrm.snapshot = self.snapshotPath;
                    vrm.timelen = 0;
                    appDelegate.video_library_data[count] = vrm;
                    BOOL ret = [NSKeyedArchiver archiveRootObject:appDelegate.video_library_data toFile:appDelegate.video_library];
                    
                    NSAssert(ret,@"写入本地视频库失败 : %@", appDelegate.video_library);

                    [self getfileSize: self.cmpsRecordPath];
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"cmps export cancelled");
                    break;
                default:
                    NSLog(@"cmps default");
                    break;
            }
        }];
        
    } else {
        self.cmpsRecordPath = nil;
        NSLog(@"I'm sorry, can't support convert this video.");
    }
}
@end

//
//  KKLocalFileManager.m
//  KaKa
//
//  Created by yxj on 3/10/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKLocalFileManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "KKAudioRecordModel.h"

@interface KKLocalFileManager() <NSFileManagerDelegate>

+(void)clearCache:(NSString *)path;
-(void)deleteFile;
//获取Documents目录
-(NSString *)dirDoc ;
//获取应用沙盒根路径
-(void)dirHome ;

@end
@implementation KKLocalFileManager

+ (KKLocalFileManager *)sharedInstance{
    static KKLocalFileManager *sharedNetwork;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetwork = [[KKLocalFileManager alloc] init];
    });
    return sharedNetwork;
}

- (void)deleteLocalAudioFiles{
    NSLog(@"%s", __func__);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    fileManager.delegate = self;
    //删除 audio 目录下的所有文件
    NSString *audioFolder = [kDocumentsPath stringByAppendingPathComponent:AUDIO_PATH];
    for (NSString *audioName in [fileManager contentsOfDirectoryAtPath:audioFolder error:nil]) {
        [fileManager removeItemAtPath:[audioFolder stringByAppendingPathComponent:audioName] error:nil];
    }
    //删除 data/audio_library.data
    NSString *audioLibInData = [[kDocumentsPath stringByAppendingPathComponent:DATA_PATH] stringByAppendingPathComponent:AUDIO_LIBRARY];
    [fileManager removeItemAtPath:audioLibInData error:nil];
    
    //清空内存中的数据
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.audio_library_data removeAllObjects];
    
    [SVProgressHUD showSuccessWithStatus:@"清空音频成功"];
}

- (void)deleteLocalVideoFiles {
    NSLog(@"%s", __func__);
//    [SVProgressHUD showProgress:10.0f];
    BOOL isSuccess = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    fileManager.delegate = self;
    //删除 video 目录下的所有文件
    NSString *videoFolder = [kDocumentsPath stringByAppendingPathComponent:VIDEO_PATH];
    for (NSString *videoName in [fileManager contentsOfDirectoryAtPath:videoFolder error:nil]) {
        if(0 == [fileManager removeItemAtPath:[videoFolder stringByAppendingPathComponent:videoName] error:nil]){
            isSuccess = NO;
        }
    }
    //删除 data/video_library.data
    NSString *videoLibInData = [[kDocumentsPath stringByAppendingPathComponent:DATA_PATH] stringByAppendingPathComponent:VIDEO_LIBRARY];
    if(0 == [fileManager removeItemAtPath:videoLibInData error:nil]){
        isSuccess = NO;
    }
    //删除 snapshot 目录下的所有文件
    NSString *snapshotFolder = [kDocumentsPath stringByAppendingPathComponent:SNAPSHOT_PATH];
    for (NSString *snapshotName in [fileManager contentsOfDirectoryAtPath:snapshotFolder error:nil]) {
        //TODO: 懒得写了
        [fileManager removeItemAtPath:[snapshotFolder stringByAppendingPathComponent:snapshotName] error:nil];
    }
    
    //清空内存中的数据
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.video_library_data removeAllObjects];
    
    [SVProgressHUD showSuccessWithStatus:@"清空视频成功"];
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error removingItemAtPath:(NSString *)path{
    NSLog(@"%s", __func__);
    NSLog(@"%@", [NSString stringWithFormat:@"%@", error]);
    [SVProgressHUD showErrorWithStatus:@"Something wrong, or maybe not..^_^"];
    return YES;
}


+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

//删除文件
-(void)deleteFile{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    BOOL res=[fileManager removeItemAtPath:testPath error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    }else
        NSLog(@"文件删除失败");
    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:testPath]?@"YES":@"NO");
}

//获取Documents目录
-(NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}



//获取应用沙盒根路径
-(void)dirHome{
    NSString *dirHome=NSHomeDirectory();
    NSLog(@"app_home: %@",dirHome);
}

- (BOOL)isLocalAudioExistWithAudioMid:(NSString *)audioMid{
//TODO: audioMid 传进来还是 long；已在字典转模型的时候强转成了 NSString？？
    audioMid = [NSString stringWithFormat:@"%@", audioMid];
    NSArray *localAudioMidList = [self getLocalAudioMidList];
    for (NSString *mid in localAudioMidList) {
        if (mid == audioMid) {
            return YES;
        }
    }
    return NO;
}



//TODO: 获取本地音频文件列表
- (NSMutableArray *)getLocalAudioMidList{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *localAudioMidList  = [NSMutableArray array];
    if (appDelegate.audio_library_data) {
        for (KKAudioRecordModel *audio in appDelegate.audio_library_data) {
            [localAudioMidList addObject:[NSString stringWithFormat:@"%ld", (long)audio.aid]];
        }
    }
    return localAudioMidList;
}


@end

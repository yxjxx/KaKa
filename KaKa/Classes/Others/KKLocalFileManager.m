//
//  KKLocalFileManager.m
//  KaKa
//
//  Created by yxj on 3/10/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKLocalFileManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KKLocalFileManager()
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
}

- (void)deleteLocalVideoFiles {
    
}

- (BOOL)isLocalAudioExistWithFileName:(NSString *)theAudioName{
    
    if ([theAudioName characterAtIndex:0] == '/') {
        NSMutableString *mutableAudioName = [theAudioName mutableCopy];
        [mutableAudioName deleteCharactersInRange:NSMakeRange(0, 1)];
        theAudioName = [[NSString alloc] initWithString:mutableAudioName];
    }
    
    NSArray *localAudioList = [self getLocalAudioList];
    
    for (NSString *audioPath in localAudioList) {
          if ([audioPath isEqualToString:theAudioName]) {
             return YES;
        }
        
    }

    return NO;
}

//TODO: 获取本地音频文件列表
- (NSArray *)getLocalAudioList{
    NSLog(@"%s", __func__);
  
    return nil;
   
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

@end

//
//  KKNetwork.m
//  KaKa
//
//  Created by yxj on 3/2/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKNetwork.h"
#import "AFNetworking.h"

@implementation KKNetwork

+ (KKNetwork *)sharedInstance{
    static KKNetwork *sharedNetwork;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetwork = [[KKNetwork alloc] init];
    });
    return sharedNetwork;
}

- (void)getVideoArrayDictWithOrder:(NSString *)order page:(NSString *)page completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"order"] = order;
    params[@"page"] = [NSString stringWithFormat:@"%@-%d", page, kPageSize];
    
    [session GET:kVideoServerAddress parameters:params progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             successBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning debuging
             NSLog(@"Fail, Error: %@", error);
             failedBlock(@"Network error");
         }];
}

- (void)getVideosOfTheUserWithKid:(NSString *)kid andPage:(NSString *)page andOrder:(NSString *)order completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"kid"] = kid;
    params[@"order"] = order;
    params[@"page"] = [NSString stringWithFormat:@"%@-%d", page, kPageSize];
    
    [session GET:kGetPersonalVideoListServerAddress parameters:params progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             successBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning debuging
             NSLog(@"Fail, Error: %@", error);
             failedBlock(@"Network error");
         }];

}

- (void)getAudioArrayDictWithPageNum:(NSString *)pageNum completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%@-%d", pageNum, kPageSize];
    
    [session GET:kAudioServerAddress parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning debuging
        NSLog(@"Fail, Error: %@", error);
        failedBlock(@"Network error");
    }];
}

- (void)downloadRemoteAudioWithURL:(NSString *)remoteAudioURL completeSuccessed:(downloadAudioSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURL *URL = [NSURL URLWithString:remoteAudioURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *dtask = [session downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:@"audio/"];
        //TODO: 需要手动创建 audio/ 文件夹
//        NSLog(@"%@", documentsDirectoryURL);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failedBlock(@"download audio failed");
        } else{
//            NSLog(@"%@", response);
            successBlock(@"downloadAudioSuccessed");
        }
#warning debuging
        NSLog(@"%@", error);
    }];
    
    [dtask resume];

}

- (void)uploadVideoWithAKKVideoRecordModel:(KKVideoRecordModel *)aVideoRecordModel completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //TODO: 参数的含义和内容需要再次确认
    params[@"vname"] = aVideoRecordModel.name;
    params[@"aid"] = [NSString stringWithFormat:@"%ld", aVideoRecordModel.aid];
    params[@"timelen"] = [NSString stringWithFormat:@"%ld", aVideoRecordModel.timelen];
    
    [session POST:kUploadVideoServerAddress parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在发送请求之前会自动调用这个 block
        NSString *videoURLStr = [[kDocumentsPath stringByAppendingPathComponent:VIDEO_PATH] stringByAppendingPathComponent: aVideoRecordModel.path];
        NSURL *videoURL = [NSURL fileURLWithPath: videoURLStr];
        [formData appendPartWithFileURL:videoURL name:@"1.mp4"  fileName:@"1.mp4" mimeType:@"video/mp4" error:nil];
        NSString *imageURLStr = [[kDocumentsPath stringByAppendingPathComponent:SNAPSHOT_PATH] stringByAppendingPathComponent: aVideoRecordModel.snapshot];
        NSURL *imageURL = [NSURL fileURLWithPath: imageURLStr];
        [formData appendPartWithFileURL:imageURL name:@"snapshot.png"  fileName:@"snapshot.png" mimeType:@"image/png" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%@", uploadProgress);
        NSLog(@"uploading...");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail, Error: %@", error);
        failedBlock(@"Upload video failed");
    }];

}

- (void)getUserInfoWithKid:(NSString *)kid completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"kid"] = kid;
    [session GET:kGetUserInfoServerAddress parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(@"Network error");
    }];
}

@end

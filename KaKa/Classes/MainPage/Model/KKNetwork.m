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
        NSLog(@"%@", error);
    }];
    
    [dtask resume];

}

@end

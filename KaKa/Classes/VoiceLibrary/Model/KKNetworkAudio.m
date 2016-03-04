//
//  KKNetworkAudio.m
//  KaKa
//
//  Created by kqy on 3/3/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKNetworkAudio.h"
#import "AFNetworking.h"

@implementation KKNetworkAudio
+ (KKNetworkAudio *)sharedInstance {
    static KKNetworkAudio *sharedNetwork;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetwork = [[KKNetworkAudio alloc]init];
    });
    return sharedNetwork;
}


- (void)getAudioArrayDictWithOrder:(NSString *)order page:(NSString *)page completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order"] = order;
    params[@"page"]  = [NSString stringWithFormat:@"%@-%d", page, kPageSize];
    [session GET:kAudioServerAddress parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail audio,error: %@",error);
    }];
}

@end

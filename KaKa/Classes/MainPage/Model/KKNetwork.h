//
//  KKNetwork.h
//  KaKa
//
//  Created by yxj on 3/2/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKVideoRecordModel.h"

typedef void(^requestSuccessed)(NSDictionary *responseJson);
//定义了一个requestSuccessed类型的代码块，返回值void，接受一个NSDictionary*类型的参数
typedef void(^requestFailed)(NSString *failedStr);
typedef void(^downloadAudioSuccessed)(NSString *successStr);


@interface KKNetwork : NSObject

+ (KKNetwork *)sharedInstance;

- (void)getVideoArrayDictWithOrder:(NSString *)order
                              page:(NSString *)page
                 completeSuccessed:(requestSuccessed)successBlock
                    completeFailed:(requestFailed)failedBlock;

- (void)getAudioArrayDictWithPageNum:(NSString *)pageNum
                   completeSuccessed:(requestSuccessed)successBlock
                      completeFailed:(requestFailed)failedBlock;


- (void)downloadRemoteAudioWithURL:(NSString *)remoteAudioURL
                 completeSuccessed:(downloadAudioSuccessed)successBlock
                    completeFailed:(requestFailed)failedBlock;

- (void)getVideosOfTheUserWithKid:(NSString *)kid
                          andPage:(NSString *)page
                         andOrder:(NSString *)order
                completeSuccessed:(requestSuccessed)successBlock
                   completeFailed:(requestFailed)failedBlock;

- (void)uploadVideoWithAKKVideoRecordModel:(KKVideoRecordModel *)aVideoRecordModel
                         completeSuccessed:(requestSuccessed)successBlock
                            completeFailed:(requestFailed)failedBlock;

- (void)getUserInfoWithKid:(NSString *)kid
         completeSuccessed:(requestSuccessed)successBlock
            completeFailed:(requestFailed)failedBlock;

- (void)getFansListWithKid:(NSString *)kid
         completeSuccessed:(requestSuccessed)successBlock
            completeFailed:(requestFailed)failedBlock;

- (void)getFollowingListWithKid:(NSString *)kid
         completeSuccessed:(requestSuccessed)successBlock
                 completeFailed:(requestFailed)failedBlock;


- (void)loginWithMobile:(NSString *)mobile
           andPasswordMD5:(NSString *)passwordMD5
        completeSuccessed:(requestSuccessed)successBlock
           completeFailed:(requestFailed)failedBlock;

- (void)setZanWithVid:(NSString *)vid withFlag:(NSString *)flag completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock;

- (void)setFavWithVid:(NSString *)vid withFlag:(NSString *)flag completeSuccessed:(requestSuccessed)successBlock completeFailed:(requestFailed)failedBlock;
@end

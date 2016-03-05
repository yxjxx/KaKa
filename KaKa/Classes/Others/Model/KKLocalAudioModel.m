//
//  KKLocalAudioModel.m
//  KaKa
//
//  Created by yxj on 3/4/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKLocalAudioModel.h"

@implementation KKLocalAudioModel

+ (KKLocalAudioModel *)sharedInstance{
    static KKLocalAudioModel *sharedLocalAudioModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocalAudioModel = [[KKLocalAudioModel alloc] init];
    });
    return sharedLocalAudioModel;
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

@end

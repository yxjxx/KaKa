//
//  KKLocalFileManager.m
//  KaKa
//
//  Created by yxj on 3/10/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKLocalFileManager.h"

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


@end

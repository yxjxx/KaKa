//
//  KKLocalFileManager.h
//  KaKa
//
//  Created by yxj on 3/10/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKLocalFileManager : NSObject

+ (KKLocalFileManager *)sharedInstance;

- (void)deleteLocalAudioFiles;

@end

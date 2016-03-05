//
//  KKLocalAudioModel.h
//  KaKa
//
//  Created by yxj on 3/4/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKLocalAudioModel : NSObject

+ (KKLocalAudioModel *)sharedInstance;

- (BOOL)isLocalAudioExistWithFileName:(NSString *)theAudioName;

@end

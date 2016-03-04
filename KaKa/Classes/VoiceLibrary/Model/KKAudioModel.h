//
//  KKAudioModel.h
//  KaKa
//
//  Created by kqy on 3/3/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKAudioModel : NSObject

@property (nonatomic, copy) NSString *audioCid;//音频分类 id
@property (nonatomic, copy) NSString *audioCName;
@property (nonatomic, copy) NSString *audioMid;//音频资源 id，唯一标识符
@property (nonatomic, copy) NSString *audioPath;
@property (nonatomic, copy) NSString *audioSubject;
@property (nonatomic, copy) NSString *audioTimestamp;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (instancetype) audioWithDict:(NSDictionary *)dict;

@end

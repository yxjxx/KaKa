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
@property (nonatomic, copy) NSString *audioPath;//音频资源在本地存放时取最后一个'/'之后的内容做文件名
@property (nonatomic, copy) NSString *audioSubject;
@property (nonatomic, copy) NSString *audioTimestamp;
@property (nonatomic, assign) BOOL isAudioExist;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (instancetype) audioWithDict:(NSDictionary *)dict;

@end

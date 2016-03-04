//
//  KKAudioModel.m
//  KaKa
//
//  Created by kqy on 3/3/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKAudioModel.h"

@implementation KKAudioModel
- (instancetype) initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.audioCid = dict[@"cid"];
        self.audioCName = dict[@"cname"];
        self.audioMid = dict[@"mid"];
        self.audioPath = dict[@"path"];
        self.audioSubject = dict[@"subject"];
        self.audioTimestamp = dict[@"timestamp"];
    }
    return self;
}
+ (instancetype) audioWithDict:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}

// 对象描述方法，类似于 Java 中的 toString() 方法
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> {audioPath: %@, audioName: %@}",self.class, self, self.audioPath, self.audioCName];
}
@end

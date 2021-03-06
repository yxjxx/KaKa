//
//  KKProfileVideoModel.m
//  KaKa
//
//  Created by kqy on 3/4/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKProfileVideoModel.h"

@implementation KKProfileVideoModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.videoName = dict[@"vname"];
        self.timelen = dict[@"timelen"];
        self.snapshot = dict[@"snapshot"];
        self.videoPath = dict[@"path"];
        self.vid = dict[@"vid"];
        self.zan = dict[@"zan"];
        self.kid = dict[@"kid"];
        self.timestamp = dict[@"timestamp"];
        self.hint = dict[@"hint"];
        self.favorite = dict[@"favorite"];
        //服务端的 long 型，使用前 [(NSNumber *)dict[@"kid"] stringValue]; 转换一下
 //       [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)videoWithDict:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}


// 对象描述方法，类似于 Java 中的 toString() 方法
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {videoName: %@, timelen: %@}", self.class, self, self.videoName, self.timelen];
}

@end

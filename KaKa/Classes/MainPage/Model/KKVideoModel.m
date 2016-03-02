//
//  KKVideoModel.m
//  KaKa
//
//  Created by yxj on 3/2/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKVideoModel.h"
#import "AFNetworking.h"
#import "KKNetwork.h"

@interface KKVideoModel()


@end

@implementation KKVideoModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.videoPath = dict[@"path"];
//        self.videoKind = dict[@"cname"];
        self.videoVName = dict[@"vname"];
        self.videoSnapshot = dict[@"snapshot"];
    }
    return self;
}

+ (instancetype)videoWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


// 对象描述方法，类似于 Java 中的 toString() 方法
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {videoPath: %@, videoName: %@}", self.class, self, self.videoPath, self.videoVName];
}


@end

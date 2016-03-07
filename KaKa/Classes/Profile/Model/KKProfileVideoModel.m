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
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)videoWithDict:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}


// 对象描述方法，类似于 Java 中的 toString() 方法
- (NSString *)description
{
    
    return [NSString stringWithFormat:@"<%@: %p> {videoPath: %@, videoName: %@}", self.class, self, self.path, self.vName];
    
}


@end

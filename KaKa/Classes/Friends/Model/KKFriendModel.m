//
//  KKFriendModel.m
//  KaKa
//
//  Created by yxj on 3/9/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKFriendModel.h"

@implementation KKFriendModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
//        self.city = dict[@"city"];
        self.kid = [NSString stringWithFormat:@"%d", (int)dict[@"kid"]];
        self.video = [NSString stringWithFormat:@"%d", (int)dict[@"video"]];
        self.portrait = dict[@"portrait"];
        self.username = dict[@"username"];
        self.fans = [NSString stringWithFormat:@"%d", (int)dict[@"fans"]];
    }
    return self;
}

+ (instancetype)friendWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

// 对象描述方法，类似于 Java 中的 toString() 方法
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> {username: %@, portrait: %@}",self.class, self, self.username, self.portrait];
}

@end
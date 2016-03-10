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
        self.kid = [(NSNumber *)dict[@"kid"] stringValue];
        self.video = [(NSNumber *)dict[@"video"] stringValue];
        self.portrait = dict[@"portrait"];
        self.username = dict[@"username"];
        self.fans = [(NSNumber *)dict[@"fans"] stringValue];
        self.attentions = [(NSNumber *)dict[@"attentions"] stringValue];
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
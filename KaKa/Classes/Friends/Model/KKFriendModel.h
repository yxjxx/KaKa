//
//  KKFriendModel.h
//  KaKa
//
//  Created by yxj on 3/9/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKFriendModel : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *kid;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fans;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (instancetype) friendWithDict:(NSDictionary *)dict;

@end

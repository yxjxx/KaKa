//
//  KKVideoModel.h
//  KaKa
//
//  Created by yxj on 3/2/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKVideoModel : NSObject

@property (nonatomic, copy) NSString *videoPath;
//@property (nonatomic, copy) NSString *videoKind;
@property (nonatomic, copy) NSString *videoVName;
@property (nonatomic, copy) NSString *videoSnapshot;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)videoWithDict:(NSDictionary *)dict;

@end

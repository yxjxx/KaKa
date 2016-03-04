//
//  KKProfileVideoModel.h
//  KaKa
//
//  Created by kqy on 3/4/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKProfileVideoModel : NSObject
@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSString *videoPath;

- (instancetype) initWithDict:(NSDictionary *)dict ;
+ (instancetype) videoWithDict:(NSDictionary *)dict;
@end

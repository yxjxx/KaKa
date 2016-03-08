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
@property (nonatomic, strong) NSString *vid;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *vName;
@property (nonatomic, strong) NSString *zan;
@property (nonatomic, strong) NSString *kid;
@property (nonatomic, strong) NSString *timelen;
@property (nonatomic, strong) NSString *hint;
@property (nonatomic, strong) NSString *favorite;
@property (nonatomic, strong) NSString *snapshot;
@property (nonatomic, strong) NSString *timestamp;



- (instancetype) initWithDict:(NSDictionary *)dict ;
+ (instancetype) videoWithDict:(NSDictionary *)dict;
@end

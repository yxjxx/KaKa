//
//  KKAudioModel.h
//  KaKa
//
//  Created by kqy on 3/3/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKAudioModel : NSObject
@property (nonatomic, copy) NSString *audioPath;
@property (nonatomic, copy) NSString *audioAName;
@property (nonatomic, copy) NSString *audioSnapshow;

- (instancetype) initWithDict:(NSDictionary *)dict;
+ (instancetype) audioWithDict:(NSDictionary *)dict;

@end

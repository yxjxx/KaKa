//
//  clearVideoAndAudio.h
//  KaKa
//
//  Created by kqy on 3/9/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface clearVideoAndAudio : NSObject

+(void)clearCache:(NSString *)path;
-(void)deleteFile;
//获取Documents目录
-(NSString *)dirDoc ;
//获取应用沙盒根路径
-(void)dirHome ;

@end

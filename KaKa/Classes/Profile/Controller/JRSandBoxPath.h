//
//  JRSandBoxPath.h
//  KaKa
//
//  Created by kqy on 3/7/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRSandBoxPath : NSObject
// 获取沙盒Document的文件目录
+ (NSString *)getDocumentDirectory;

// 获取沙盒Library的文件目录
+ (NSString *)getLibraryDirectory;

// 获取沙盒Library/Caches的文件目录
+ (NSString *)getCachesDirectory;

// 获取沙盒Preference的文件目录
+ (NSString *)getPreferencePanesDirectory;

// 获取沙盒tmp的文件目录
+ (NSString *)getTmpDirectory;
@end

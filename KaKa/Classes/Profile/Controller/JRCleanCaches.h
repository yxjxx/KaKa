//
//  JRCleanCaches.h
//  KaKa
//
//  Created by kqy on 3/7/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCleanCaches : NSObject

+ (double)sizeWithFilePath:(NSString *)path;

// 得到指定目录下的所有文件
+ (NSArray *)getAllFileNames:(NSString *)dirPath;

// 删除指定目录或文件
+ (BOOL)clearCachesWithFilePath:(NSString *)path;

// 清空指定目录下文件
+ (BOOL)clearCachesFromDirectoryPath:(NSString *)dirPath;


@end

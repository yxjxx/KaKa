//
//  KKVideoRecordModel.h
//  KaKa
//
//  Created by Linzer on 16/3/4.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKVideoRecordModel : NSObject<NSCoding>

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *snapshot;
@property (strong, nonatomic) NSString *name;
@property (unsafe_unretained, nonatomic) NSInteger aid;
@property (unsafe_unretained, nonatomic) NSInteger timelen;

@end

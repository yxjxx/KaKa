//
//  KKAudioRecordModel.h
//  KaKa
//
//  Created by Linzer on 16/3/4.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKAudioModel.h"

@interface KKAudioRecordModel : NSObject <NSCoding>

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *subject;
@property (unsafe_unretained, nonatomic) NSInteger aid;

+ (KKAudioRecordModel *)sharedInstance;

- (BOOL)isLocalAudioExistWithFileName:(NSString *)theAudioName;
- (BOOL)updateGlobalAudioLibraryData:(KKAudioModel *)audioModel;


@end

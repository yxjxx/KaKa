//
//  AppDelegate.h
//  KaKa
//
//  Created by yxj on 16/2/24.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *video_dir;
@property (strong, nonatomic) NSString *audio_dir;
@property (strong, nonatomic) NSString *snapshot_dir;
@property (strong, nonatomic) NSString *data_dir;
@property (strong, nonatomic) NSString *video_library;
@property (strong, nonatomic) NSString *audio_library;
@property (strong, nonatomic) NSMutableArray *video_library_data;
@property (strong, nonatomic) NSMutableArray *audio_library_data;


@end


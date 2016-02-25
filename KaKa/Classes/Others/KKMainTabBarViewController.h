//
//  KKMainTabBarViewController.h
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMainPageViewController.h"
#import "KKVoiceLibraryViewController.h"
#import "KKCameraViewController.h"
#import "KKFriendsViewController.h"
#import "KKProfileViewController.h"

@interface KKMainTabBarViewController : UITabBarController

@property (nonatomic, strong) KKMainPageViewController *mainPageVC;
@property (nonatomic, strong) KKVoiceLibraryViewController *voiceLibraryVC;
@property (nonatomic, strong) KKCameraViewController *cameraVC;
@property (nonatomic, strong) KKFriendsViewController *friendsVC;
@property (nonatomic, strong) KKProfileViewController *profileVC;

@end

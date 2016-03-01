//
//  KKMainTabBarViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKMainTabBarViewController.h"

@implementation KKMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = [NSArray arrayWithObjects:
                            self.mainPageVC,
                            self.voiceLibraryVC,
                            self.cameraVC,
                            self.friendsVC,
                            self.profileVC,
                            nil];
    
    [self.navigationItem setHidesBackButton:YES];
    
}


- (KKMainPageViewController *)mainPageVC{
    if (_mainPageVC == nil) {
        _mainPageVC = [[KKMainPageViewController alloc] init];
        _mainPageVC.tabBarItem.title = @"Main Page";
//        _mainPageVC.tabBarItem.image = 
    }
    return _mainPageVC;
}

- (KKVoiceLibraryViewController *)voiceLibraryVC{
    if (_voiceLibraryVC == nil) {
        _voiceLibraryVC = [[KKVoiceLibraryViewController alloc] init];
        _voiceLibraryVC.tabBarItem.title = @"Voice Lib";
    }
    return _voiceLibraryVC;
}

//- (KKCameraViewController *)cameraVC{
//    if (_cameraVC == nil) {
//        _cameraVC = [[KKCameraViewController alloc] init];
//        _cameraVC.tabBarItem.title = @"Camera";
//    }
//    return _cameraVC;
//}

- (KKFriendsViewController *)friendsVC{
    if (_friendsVC == nil) {
        _friendsVC = [[KKFriendsViewController alloc] init];
        _friendsVC.tabBarItem.title = @"Friend";
    }
    return _friendsVC;
}

- (KKProfileViewController *)profileVC{
    if (_profileVC == nil) {
        _profileVC = [[KKProfileViewController alloc] init];
        _profileVC.tabBarItem.title = @"Profile";
    }
    return _profileVC;
}







@end

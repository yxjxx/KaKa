//
//  AppDelegate.m
//  KaKa
//
//  Created by yxj on 16/2/24.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "AppDelegate.h"
#import "KKMainTabBarViewController.h"
#import "CYLTabBarController.h"
#import "KKMainPageViewController.h"
#import "KKVoiceLibraryViewController.h"
#import "KKFriendsViewController.h"
#import "KKProfileViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) CYLTabBarController *tabBarController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [NSThread sleepForTimeInterval:1];
//    self.window.rootViewController = [[KKMainTabBarViewController alloc]init];
    [self setupViewControllers];
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    
    
    /* Append By Linzer At 2016/03/01 */
    NSString *document_dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    
    self.video_dir = [document_dir stringByAppendingPathComponent: VIDEO_PATH];
    self.audio_dir = [document_dir stringByAppendingPathComponent: AUDIO_PATH];
    self.snapshot_dir = [document_dir stringByAppendingPathComponent: SNAPSHOT_PATH];
    self.data_dir = [document_dir stringByAppendingPathComponent: DATA_PATH];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    BOOL ret = [fm createDirectoryAtPath:self.video_dir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSAssert(ret,@"创建目录失败 : %@", self.video_dir);
    
    ret = [fm createDirectoryAtPath:self.audio_dir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSAssert(ret,@"创建目录失败 : %@", self.audio_dir);
    
    ret = [fm createDirectoryAtPath:self.snapshot_dir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSAssert(ret,@"创建目录失败 : %@", self.snapshot_dir);
    
    ret = [fm createDirectoryAtPath:self.data_dir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSAssert(ret,@"创建目录失败 : %@", self.data_dir);
    
    self.audio_library = [self.data_dir stringByAppendingPathComponent: AUDIO_LIBRARY];
    self.video_library = [self.data_dir stringByAppendingPathComponent: VIDEO_LIBRARY];
    
    // 加载本地视频库
    if ([fm fileExistsAtPath:self.audio_library]) {
        
        self.audio_library_data = [NSKeyedUnarchiver unarchiveObjectWithFile:self.audio_library];
        
        NSLog(@"KaKa:%lu", self.audio_library_data.count);
        
    }
    
    
    if(!self.audio_library_data){
        self.audio_library_data = [[NSMutableArray alloc]init];
    }
    
    if ([fm fileExistsAtPath:self.video_library]) {
        
        self.video_library_data = [NSKeyedUnarchiver unarchiveObjectWithFile:self.video_library];
        
        NSLog(@"KaKa:%lu", self.video_library_data.count);
        
    }
    
    
    if(!self.video_library_data){
        self.video_library_data = [[NSMutableArray alloc]init];
    }
    
    return YES;
}

- (void)setupViewControllers {
    KKMainPageViewController *firstViewController = [[KKMainPageViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];

    KKVoiceLibraryViewController *secondViewController = [[KKVoiceLibraryViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];

    KKFriendsViewController *thirdViewController = [[KKFriendsViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];

    KKProfileViewController *fourthViewController = [[KKProfileViewController alloc] init];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];


    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];

    [tabBarController setViewControllers:@[
                                           firstNavigationController,
                                           secondNavigationController,
                                           thirdNavigationController,
                                           fourthNavigationController
                                           ]];
    self.tabBarController = tabBarController;
}

/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {

    NSDictionary *dict1 = @{
                            // CYLTabBarItemTitle : @"MainPage",
                            CYLTabBarItemImage : @"MainPage",
                            CYLTabBarItemSelectedImage : @"MainPage-1",

                            };
    NSDictionary *dict2 = @{
                            // CYLTabBarItemTitle : @"Voice",
                            CYLTabBarItemImage : @"Voice",
                            CYLTabBarItemSelectedImage : @"Voice-1",
                            };

    NSDictionary *dict3 = @{
                            // CYLTabBarItemTitle : @"Friends",
                            CYLTabBarItemImage : @"Friends",
                            CYLTabBarItemSelectedImage : @"Friends-1",
                            };
    NSDictionary *dict4 = @{
                            // CYLTabBarItemTitle : @"Profile",
                            CYLTabBarItemImage : @"Profile",
                            CYLTabBarItemSelectedImage : @"Profile-1",
                            };

    NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3, dict4 ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

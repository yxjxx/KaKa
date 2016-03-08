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

//    [NSThread sleepForTimeInterval:0.1];
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
    
//TODO:  22,22,22RGB.设好这后 取色，并不是22,22,22
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:22/256.0 green:22/256.0 blue:22/256.0 alpha:1]];
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];

    [tabBarController setViewControllers:@[
                                           firstNavigationController,
                                           secondNavigationController,
                                           thirdNavigationController,
                                           fourthNavigationController
                                           ]];
    [[self class] customizeTabBarAppearance:tabBarController];
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

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
+ (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    
    //去除 TabBar 自带的顶部阴影
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    NSUInteger allItemsInTabBarCount = [CYLTabBarController allItemsInTabBarCount];
    //TODO: TabBarItem选中后的背景颜色
    [[UITabBar appearance] setSelectionIndicatorImage:[self imageFromColor:[UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1] forSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / allItemsInTabBarCount, 49.f) withCornerRadius:0]];
    
    // set the bar background color
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background_ios7"]];
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    return image;
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

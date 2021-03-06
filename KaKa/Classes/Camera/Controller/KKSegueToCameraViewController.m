//
//  KKCameraViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKSegueToCameraViewController.h"
#import "KKCameraViewController.h"
#import "KKUploadVideoViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation KKSegueToCameraViewController


+ (void)load{
    [super registerSubclass];
}

//+ (NSUInteger)indexOfPlusButtonInTabBar{
//    return 3;
//}

+ (CGFloat)multiplerInCenterY{
    return 0.39;
  //  return 0.0;
}

+ (instancetype)plusButton{
    KKSegueToCameraViewController *button = [[KKSegueToCameraViewController alloc] init];
    
//    button.layer.cornerRadius = 34;
//    button.clipsToBounds = YES;
    [button setImage:[UIImage imageNamed:@"KK_Camera_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"KK_Camera_selected"] forState:UIControlStateHighlighted];

    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
//    [button sizeToFit];
     [button setSize:CGSizeMake(75, 49)];
//    [button setBackgroundColor:[UIColor clearColor]];
#warning debuging
    NSLog(@"%@", button);
    [button addTarget:button action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
    return button;

}

- (void)clickCamera{
#warning testing
    NSLog(@"%s", __func__);
    KKCameraViewController *cameraVC = [[KKCameraViewController alloc] init];
    KKUploadVideoViewController *uploadVideoVC = [[KKUploadVideoViewController alloc] init];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *viewController = tabBarController.selectedViewController;
    [viewController presentViewController:cameraVC animated:YES completion:nil];
//    [viewController presentViewController:uploadVideoVC animated:YES completion:nil];

}




@end

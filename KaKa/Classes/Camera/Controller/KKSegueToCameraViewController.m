//
//  KKCameraViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKSegueToCameraViewController.h"
#import "KKCameraViewController.h"

@implementation KKSegueToCameraViewController


//- (void)viewDidLoad{
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor blackColor];
//}

+ (void)load{
    [super registerSubclass];
}

//+ (NSUInteger)indexOfPlusButtonInTabBar{
//    return 3;
//}

+ (CGFloat)multiplerInCenterY{
    return 0.3;
}

+ (instancetype)plusButton{
    KKSegueToCameraViewController *button = [[KKSegueToCameraViewController alloc] init];
    
    //TODO: KK_Camera.png 替换
    [button setImage:[UIImage imageNamed:@"KK_Camera"] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    [button sizeToFit];
    
    [button addTarget:button action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
    return button;

}

- (void)clickCamera{
    NSLog(@"%s", __func__);
    KKCameraViewController *cameraVC = [[KKCameraViewController alloc] init];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *viewController = tabBarController.selectedViewController;
    

    
    [viewController presentViewController:cameraVC animated:YES completion:nil];

}




@end

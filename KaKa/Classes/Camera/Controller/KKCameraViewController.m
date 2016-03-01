//
//  KKCameraViewController.m
//  KaKa
//
//  Created by yxj on 16/2/25.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKCameraViewController.h"

@implementation KKCameraViewController


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
    KKCameraViewController *button = [[KKCameraViewController alloc] init];
    
    [button setImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
//    [button setTitle:@"Publish" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    [button sizeToFit];
    
    [button addTarget:button action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
    return button;

}

- (void)clickCamera{
    NSLog(@"%s", __func__);
}




@end

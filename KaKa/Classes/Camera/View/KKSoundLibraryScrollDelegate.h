//
//  KKSoundLibraryScrollDelegate.h
//  KaKa
//
//  Created by Linzer on 16/3/5.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKSoundLibraryScrollDelegate <NSObject, UIScrollViewDelegate>
@optional  //可选
-(void)clickSoundLibraryItem:(id)sender;
@end
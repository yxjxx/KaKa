//
//  KKSoundLibraryItemView.h
//  KaKa
//
//  Created by Linzer on 16/3/3.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAudioRecordModel.h"

@class KKSoundLibraryScrollView;

@interface KKSoundLibraryItemView : UIView
@property (strong, nonatomic) UIImage *normalBackground;
@property (strong, nonatomic) UIImage *selectedBackground;
@property (strong, nonatomic) KKAudioRecordModel *model;
@property (weak, nonatomic) KKSoundLibraryScrollView *parent;

-(void) setSelected:(BOOL)flag;
@end

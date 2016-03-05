//
//  KKSoundLibraryScrollView.h
//  KaKa
//
//  Created by Linzer on 16/3/3.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAudioRecordModel.h"
#import "KKSoundLibraryItemView.h"
#import "KKSoundLibraryScrollDelegate.h"

@interface KKSoundLibraryScrollView : UIScrollView
@property (weak, nonatomic) id<KKSoundLibraryScrollDelegate>delegate;
@property (weak, nonatomic, readonly) KKSoundLibraryItemView *selectedItem;

-(void) addItemWithModel:(KKAudioRecordModel *)model;

-(void) clickSoundLibraryItem:(id)sender;
@end

//
//  KKSoundLibraryScrollView.m
//  KaKa
//
//  Created by Linzer on 16/3/3.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKSoundLibraryScrollView.h"

@interface KKSoundLibraryScrollView()

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation KKSoundLibraryScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    
    if (self) {
        self.frame = frame;
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) addItemWithModel:(KKAudioRecordModel *)model{
    
    if(!self.items){
        self.items = [[NSMutableArray alloc] init];
    }
    CGSize size;
    size.height = self.frame.size.height;
    size.width = size.height * 68 / 70;
    
    CGPoint pt;
    pt.x = self.items.count * size.width;
    pt.y = 0;
    
    CGRect rect = CGRectMake(pt.x, pt.y, size.width, size.height);
    
    KKSoundLibraryItemView * slv =
    [[KKSoundLibraryItemView alloc] initWithFrame:rect];
    slv.normalBackground = [UIImage imageNamed:@"headset"];
    slv.selectedBackground = [UIImage imageNamed:@"headsetSel"];
    slv.model = model;
    slv.parent = self;
    
    self.items[self.items.count] = slv;
    [self addSubview:slv];
    
    size.width *= self.items.count;
    self.contentSize = size;
}

-(void) clickSoundLibraryItem:(id)sender{
    _selectedItem = sender;
    
    for (int i=0; i<_items.count; ++i) {
        [((KKSoundLibraryItemView *)_items[i]) setSelected:NO];
    }
    
    [((KKSoundLibraryItemView *)sender) setSelected:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSoundLibraryItem:)]) {
        [self.delegate clickSoundLibraryItem:self];
    }
}

@end

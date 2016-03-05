//
//  KKSoundLibraryItemView.m
//  KaKa
//
//  Created by Linzer on 16/3/3.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKSoundLibraryItemView.h"
#import "KKSoundLibraryScrollView.h"

@interface KKSoundLibraryItemView()
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *label;
@end

@implementation KKSoundLibraryItemView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initDefault{    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    
    if (self) {
        self = [self initDefault];
        self.frame = frame;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.label = [[UILabel alloc]init];
        
        self.button.frame = CGRectMake(frame.size.width * 10 / 68, 0, frame.size.width * 48 / 68, frame.size.width * 48 / 68);
        
        self.label.frame = CGRectMake(frame.size.width * 10 / 68, frame.size.height * 50 / 70, frame.size.width * 48 / 68, frame.size.height * 20 / 70);
        
        [self.button setBackgroundImage:self.normalBackground forState:UIControlStateNormal];
        [self.button setBackgroundImage:self.selectedBackground forState:UIControlStateSelected];
        
        [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.button.layer setMasksToBounds:YES];
        [self.button.layer setCornerRadius:self.button.frame.size.width / 2]; //设置矩形四个圆角半径
        [self.button.layer setBorderWidth:0]; //边框宽度
        /*
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
        [self.button.layer setBorderColor:colorref];//边框颜色
        */
        self.label.text = self.model.subject;
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:10];
        self.label.textAlignment = UITextAlignmentCenter;
        [self addSubview: self.button];
        [self addSubview: self.label];
        
    }
    
    return self;
}

-(void)click:(id)sender{
    if (_parent && [_parent respondsToSelector:@selector(clickSoundLibraryItem:)]) {
        [_parent clickSoundLibraryItem:self];
    }
}

- (void) setNormalBackground:(UIImage *)normalBackground{
    _normalBackground = normalBackground;
    [self.button setBackgroundImage:_normalBackground forState:UIControlStateNormal];
}

- (void) setSelectedBackground:(UIImage *)selectedBackground{
    _selectedBackground = selectedBackground;
    [self.button setBackgroundImage:_selectedBackground forState:UIControlStateSelected];
}

- (void) setModel: (KKAudioRecordModel *)model{
    _model = model;
    self.label.text = _model.subject;
}

-(void) setSelected:(BOOL)flag{
    [_button setSelected:flag];
}

- (void) drawRect:(CGRect)rect {
    // Drawing code
    
}

@end

//
//  KKVideoCell.m
//  KaKa
//
//  Created by yxj on 3/2/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKVideoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

@interface KKVideoCell()

@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UILabel *videoNameLabel;
@property (nonatomic, strong) UILabel *videoTimeLabel;

@end

@implementation KKVideoCell

- (UIImageView *)snapImageView{
    if (_snapImageView == nil) {
        _snapImageView = [[UIImageView alloc] init];
        _snapImageView.frame = CGRectMake(0, 0, kSnapshotWidth, kSnapshotWidth);
        [self.contentView addSubview:_snapImageView];
    }
    return _snapImageView;
}

- (UILabel *)videoNameLabel{
    if (_videoNameLabel == nil) {
        _videoNameLabel = [[UILabel alloc] init];
//        _videoNameLabel.frame = CGRectMake(60, 0, 200, 30);
        _videoNameLabel.textAlignment = NSTextAlignmentCenter;
//TODO: text color and font size
        _videoNameLabel.textColor = [UIColor whiteColor];
        _videoNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_videoNameLabel];
        [_videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.centerX);
            make.height.equalTo(@30);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
        [_videoNameLabel showPlaceHolder];
    }
    return _videoNameLabel;
}

- (UILabel *)videoTimeLabel{
    if (_videoTimeLabel == nil) {
        _videoTimeLabel = [[UILabel alloc] init];
        _videoTimeLabel.frame = CGRectMake(60, 30, 200, 30);
        [self.contentView addSubview:_videoTimeLabel];
    }
    return _videoTimeLabel;
}

- (void)setAVideoModel:(KKVideoModel *)aVideoModel{
    _aVideoModel = aVideoModel;
    
    [self setData];
    
}

- (void)setData{
    //TODO: 换一张 placeholder.png
    [self.snapImageView sd_setImageWithURL:[NSURL URLWithString:self.aVideoModel.videoSnapshot] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.videoNameLabel.text = self.aVideoModel.videoVName;
//    self.videoTimeLabel.text = @"2 hours ago";
}




@end

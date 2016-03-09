//
//  KKProfileVideoCell.m
//  KaKa
//
//  Created by kqy on 3/4/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKProfileVideoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"


@interface KKProfileVideoCell ()
@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UILabel *videoNameLabel;
@property (nonatomic, strong) UILabel *videoTimeLabel;

@end

@implementation KKProfileVideoCell

- (UIImageView *)snapImageView {
    if (_snapImageView == nil) {
        _snapImageView = [[UIImageView alloc] init];
        _snapImageView.frame = CGRectMake(kMagicZero, kMagicZero, kSnapshotWidthForProfile, kSnapshotWidthForProfile);
        [self.contentView addSubview:_snapImageView];
    }
    return _snapImageView;
}

- (UILabel *)videoNameLabel{
    if (_videoNameLabel == nil) {
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.textAlignment = NSTextAlignmentCenter;
        //TODO: text color and font size
        _videoNameLabel.textColor = [UIColor whiteColor];
        _videoNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_videoNameLabel];
        [_videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.centerX);
            make.height.equalTo(@20);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
    }
    return _videoNameLabel;
}

- (void)setAVideoModel:(KKProfileVideoModel *)aVideoModel {
    _aVideoModel = aVideoModel;
    
    [self setData];
}

- (void)setData{
   //????????
    self.videoNameLabel.text = self.aVideoModel.videoName;
    self.videoTimeLabel.text = self.aVideoModel.timelen;
    [self.snapImageView sd_setImageWithURL:[NSURL URLWithString:self.aVideoModel.snapshot] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}


@end

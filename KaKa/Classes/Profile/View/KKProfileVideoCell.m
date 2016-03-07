//
//  KKProfileVideoCell.m
//  KaKa
//
//  Created by kqy on 3/4/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKProfileVideoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface KKProfileVideoCell ()
@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UILabel *videoNameLabel;
@property (nonatomic, strong) UILabel *videoTimeLabel;

@end

@implementation KKProfileVideoCell

- (UIImageView *)snapImageView {
    [_snapImageView showPlaceHolder];
    if (_snapImageView == nil) {
        _snapImageView = [[UIImageView alloc] init];
        _snapImageView.frame = CGRectMake(0, 0, kSnapshotWidth, kSnapshotWidth);
        [self.contentView addSubview:_snapImageView];
    }
    return _snapImageView;
}

- (UILabel *)videoNameLabel {
    [_videoNameLabel showPlaceHolder];
    if (_videoNameLabel == nil) {
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.frame = CGRectMake(0, 0, 200, 30);
        _videoNameLabel.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_videoNameLabel];
    }
    return _videoNameLabel;
}

//  - (UILabel *)videoTimeLabel

- (void)setAVideoModel:(KKProfileVideoModel *)aVideoModel {
    _aVideoModel = aVideoModel;
    
    [self setData];
}

- (void)setData {
    
    [self.snapImageView sd_setImageWithURL:[NSURL URLWithString:self.aVideoModel.snapshot] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.videoNameLabel.text = self.aVideoModel.vName;
    //    self.videoTimeLabel.text = @"2 hours ago";
    
    
}


@end

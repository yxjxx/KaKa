//
//  KKProfileVideoCell.m
//  KaKa
//
//  Created by kqy on 3/4/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKProfileVideoCell.h"

@interface KKProfileVideoCell ()
@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UILabel *videoNameLabel;
@property (nonatomic, strong) UILabel *videoTimeLabel;

@end

@implementation KKProfileVideoCell

- (UIImageView *)snapImageView {
    if (_snapImageView == nil) {
        _snapImageView = [[UIImageView alloc] init];
        _snapImageView.frame = CGRectMake(0, 0, kSnapshotWidth, kSnapshotWidth);
        [self.contentView addSubview:_snapImageView];
    }
    return _snapImageView;
}

- (UILabel *)videoNameLabel {
    if (_videoNameLabel == nil) {
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.frame = CGRectMake(60, 0, 200, 30);
        [self.contentView addSubview:_videoNameLabel];
    }
    return _videoNameLabel;
}

- (UILabel *)videoTimeLabel {
    if (_videoTimeLabel == nil) {
        _videoTimeLabel = [[UILabel alloc]init ];
        _videoTimeLabel.frame = CGRectMake(0, 0, 30, 30);
        [self.contentView addSubview:_videoTimeLabel];
    }
    return _videoTimeLabel;
}  //wrong!!!!!

- (void)setAVideoModel:(KKProfileVideoModel *)aVideoModel {
    _aVideoModel = aVideoModel;
    
    [self setData];
}

- (void)setData{
   //????????
    self.videoNameLabel.text = self.aVideoModel.videoName;
    self.videoTimeLabel.text = self.aVideoModel.timelen;
}


@end

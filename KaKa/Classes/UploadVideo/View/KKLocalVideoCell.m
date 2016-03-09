//
//  KKLocalVideoCell.m
//  KaKa
//
//  Created by yxj on 3/8/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKLocalVideoCell.h"

@interface KKLocalVideoCell()

@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UILabel *videoNameLabel;

@end

@implementation KKLocalVideoCell

- (UIImageView *)snapImageView {
    if (_snapImageView == nil) {
        _snapImageView = [[UIImageView alloc] init];
        _snapImageView.frame = CGRectMake(kMagicZero, kMagicZero, kSnapshotWidthForProfile, kSnapshotWidthForProfile);
        [self.contentView addSubview:_snapImageView];
    }
    return _snapImageView;
}

- (UILabel *)videoNameLabel {
    if (_videoNameLabel == nil) {
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.frame = CGRectMake(10, 10, 200, 30);
        [self.contentView addSubview:_videoNameLabel];
    }
    return _videoNameLabel;
}

- (void)setAVideoModel:(KKVideoRecordModel *)aVideoModel {
    _aVideoModel = aVideoModel;
    
    [self setData];
}

- (void)setData{
    self.videoNameLabel.text = self.aVideoModel.name;
    NSString *snapshotLocation = [[kDocumentsPath stringByAppendingPathComponent:SNAPSHOT_PATH] stringByAppendingPathComponent:self.aVideoModel.snapshot];
    self.snapImageView.image = [UIImage imageWithContentsOfFile:snapshotLocation];
}


@end

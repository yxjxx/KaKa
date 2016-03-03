//
//  KKAudioCell.m
//  KaKa
//
//  Created by kqy on 3/3/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKAudioCell.h"

@interface KKAudioCell ()
@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UILabel *audioNameLabel;
@property (nonatomic, strong) UILabel *audioTimeLabel;
 
@end

@implementation KKAudioCell
- (UIImageView *)snapImageView {
    if (_snapImageView == nil) {
        _snapImageView = [[UIImageView alloc]init];
        _snapImageView.frame = CGRectMake(0, 0, 60, 60);
        [self.contentView addSubview:_snapImageView];
    }
    return _snapImageView;
}

- (UILabel *)audioNameLabel {
    if (_audioNameLabel == nil) {
        _audioNameLabel = [[UILabel alloc]init];
        _audioNameLabel.frame = CGRectMake(60, 0, 200, 30);
        [self.contentView addSubview:_audioNameLabel];
    }
    return _audioNameLabel;
}

- (UILabel *)audioTimeLabel {
    if (_audioTimeLabel == nil) {
        _audioTimeLabel = [[UILabel alloc]init];
        _audioTimeLabel.frame = CGRectMake(60, 30, 200, 30);
        [self.contentView addSubview:_audioTimeLabel];
    }
    return _audioTimeLabel;
}

- (void)setAAudioModel:(KKAudioModel *)aAudioModel {
    _aAudioModel = aAudioModel;
    [self setData];
}


- (void)setData {
    self.snapImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.aAudioModel.audioSnapshow] ]];
    self.audioNameLabel.text = self.aAudioModel.audioAName;
    self.audioTimeLabel.text = @"6 minutes ago";
}

@end

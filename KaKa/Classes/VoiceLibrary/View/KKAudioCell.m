//
//  KKAudioCell.m
//  KaKa
//
//  Created by kqy on 3/3/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKAudioCell.h"

@interface KKAudioCell ()

@property (nonatomic, strong) UIImageView *leftLmageView;
@property (nonatomic, strong) UILabel *audioCNameLabel;
@property (nonatomic, strong) UILabel *audioSubjectLabel;
@property (nonatomic, strong) UIImageView *isExistImageView;
 
@end

@implementation KKAudioCell

- (UIImageView *)isExistImageView{
    if (_isExistImageView == nil) {
        _isExistImageView = [[UIImageView alloc] init];
        _isExistImageView.frame = CGRectMake(kScreenWidth-65, 0, 65, 65);
        [self.contentView addSubview:_isExistImageView];
    }
    return _isExistImageView;
}


- (UIImageView *)leftLmageView {
    if (_leftLmageView == nil) {
        _leftLmageView = [[UIImageView alloc]init];
        _leftLmageView.frame = CGRectMake(0, 0, 55, 60);
        [self.contentView addSubview:_leftLmageView];
    }
    return _leftLmageView;
}

- (UILabel *)audioCNameLabel {
    if (_audioCNameLabel == nil) {
        _audioCNameLabel = [[UILabel alloc]init];
        _audioCNameLabel.frame = CGRectMake(60, 5, 200, 30);
        [self.contentView addSubview:_audioCNameLabel];
    }
    return _audioCNameLabel;
}

- (UILabel *)audioSubjectLabel {
    if (_audioSubjectLabel == nil) {
        _audioSubjectLabel = [[UILabel alloc]init];
        _audioSubjectLabel.frame = CGRectMake(60, 30, 200, 30);
        _audioSubjectLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_audioSubjectLabel];
    }
    return _audioSubjectLabel;
}

- (void)setAAudioModel:(KKAudioModel *)aAudioModel {
    _aAudioModel = aAudioModel;
    [self setData];
}


- (void)setData {
//    self.leftLmageView.image = [UIImage imageWithContentsOfFile:@"d"];
    self.leftLmageView.image = [UIImage imageNamed:@"VoiceLibIcon"];
    self.audioCNameLabel.text = self.aAudioModel.audioCName;
    self.audioSubjectLabel.text = self.aAudioModel.audioSubject;
    if ([self.audioCNameLabel.text isEqualToString:@"电视剧"]) {
        self.audioCNameLabel.textColor = [UIColor colorWithRed:210/256.0 green:90/256.0 blue:90/256.0 alpha:0.8];
    }
    else if([self.audioCNameLabel.text isEqualToString:@"动画片"]) {
        self.audioCNameLabel.textColor = [UIColor colorWithRed:210/256.0 green:160/256.0 blue:90/256.0 alpha:0.8];
    } else if([self.audioCNameLabel.text isEqualToString:@"原创精选"]) {
        self.audioCNameLabel.textColor = [UIColor colorWithRed:130/256.0 green:210/256.0 blue:90/256.0 alpha:0.8];
    } else if([self.audioCNameLabel.text isEqualToString:@"电影"]) {
        self.audioCNameLabel.textColor = [UIColor colorWithRed:90/256.0 green:180/256.0 blue:210/256.0 alpha:0.8];
    } else{
        self.audioCNameLabel.textColor = [UIColor colorWithRed:190/256.0 green:280/256.0 blue:210/256.0 alpha:0.8];
    }
    
    if (self.aAudioModel.isAudioExist) {
        self.isExistImageView.image = [UIImage imageNamed:@"VoiceLibIcon"];
    } else{
        self.isExistImageView.image = [UIImage imageNamed:@"VoiceLibIcon"];
    }
    
}

@end

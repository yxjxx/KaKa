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
 
@end

@implementation KKAudioCell
- (UIImageView *)leftLmageView {
    if (_leftLmageView == nil) {
        _leftLmageView = [[UIImageView alloc]init];
        _leftLmageView.frame = CGRectMake(0, 0, 60, 60);
        [self.contentView addSubview:_leftLmageView];
    }
    return _leftLmageView;
}

- (UILabel *)audioCNameLabel {
    if (_audioCNameLabel == nil) {
        _audioCNameLabel = [[UILabel alloc]init];
        _audioCNameLabel.frame = CGRectMake(60, 30, 200, 30);
        [self.contentView addSubview:_audioCNameLabel];
    }
    return _audioCNameLabel;
}

- (UILabel *)audioSubjectLabel {
    if (_audioSubjectLabel == nil) {
        _audioSubjectLabel = [[UILabel alloc]init];
        _audioSubjectLabel.frame = CGRectMake(60, 0, 200, 30);
        [self.contentView addSubview:_audioSubjectLabel];
    }
    return _audioSubjectLabel;
}

- (void)setAAudioModel:(KKAudioModel *)aAudioModel {
    _aAudioModel = aAudioModel;
    [self setData];
}


- (void)setData {
//    self.leftLmageView.image = [UIImage imageWithContentsOfFile:<#(nonnull NSString *)#>];
    self.leftLmageView.image = [UIImage imageNamed:@"KK_Camera"];
    self.audioCNameLabel.text = self.aAudioModel.audioCName;
    self.audioSubjectLabel.text = self.aAudioModel.audioSubject;
}

@end

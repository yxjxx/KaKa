//
//  KKFriendTableViewCell.m
//  KaKa
//
//  Created by yxj on 3/9/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKFriendTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KKFriendTableViewCell()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *videoNumberLabel;

@end

@implementation KKFriendTableViewCell

- (UIImageView *)portraitImageView{
    if (_portraitImageView == nil) {
        _portraitImageView = [[UIImageView alloc] init];
        _portraitImageView.frame = CGRectMake(0, 7, 55, 51);
        [self.contentView addSubview:_portraitImageView];
    }
    return _portraitImageView;
}

- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.frame = CGRectMake(60, 15, 200, 30);
        [self.contentView addSubview:_usernameLabel];
    }
    return _usernameLabel;
}

- (UILabel *)videoNumberLabel{
    if (_videoNumberLabel == nil) {
        _videoNumberLabel = [[UILabel alloc] init];
//TODO: adjust frame for this cell
        _videoNumberLabel.size = CGSizeMake(200, 60);
        _videoNumberLabel.center = CGPointMake(kScreenWidth-110, 30);
        _videoNumberLabel.textAlignment = NSTextAlignmentRight;
//        _videoNumberLabel.frame = CGRectMake(60, 30, 200, 30);
        [self.contentView addSubview:_videoNumberLabel];
    }
    return _videoNumberLabel;
}

- (void)setFriendModel:(KKFriendModel *)friendModel{
    _friendModel = friendModel;
    [self setData];
    [self setUI];
}

- (void)setData{
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.friendModel.portrait] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.portraitImageView.layer.masksToBounds = YES;
    self.portraitImageView.layer.cornerRadius = CGRectGetHeight(self.portraitImageView.frame) / 2.0;
//    NSLog(@"%@...",self.portraitImageView.frame.size);
 
    
    
    self.usernameLabel.text = self.friendModel.username;
    self.videoNumberLabel.text = [NSString stringWithFormat:@"%@个粉丝", self.friendModel.fans];
    
    self.usernameLabel.textColor = [UIColor grayColor];
    self.videoNumberLabel.textColor = [UIColor grayColor];
    
    
    
}

- (void)setUI{
    self.contentView.backgroundColor = [UIColor colorWithRed:45/256.0 green:45/256.0 blue:45/256.0 alpha:1];

}




@end

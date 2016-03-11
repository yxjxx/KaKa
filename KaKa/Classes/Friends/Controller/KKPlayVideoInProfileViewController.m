//
//  KKPlayVideoInProfileViewController.m
//  KaKa
//
//  Created by yxj on 3/10/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKPlayVideoInProfileViewController.h"
#import "KRVideoPlayerController.h"
#import "KKNetwork.h"

@interface KKPlayVideoInProfileViewController()

@property (nonatomic, strong) KRVideoPlayerController *videoController;

@end

@implementation KKPlayVideoInProfileViewController

- (void)zanClick:(id)sender{
    UIButton * zanBtn = (UIButton *)sender;
    [zanBtn setSelected:![zanBtn isSelected]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *kid = [defaults objectForKey:@"kid"];
    [[KKNetwork sharedInstance] setZanWithKid:kid withVid:@"1" withFlag:@"true" completeSuccessed:^(NSDictionary *responseJson) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![responseJson[@"errcode"] isEqual: [NSNumber numberWithInteger:0]]) {
                
                NSString *msg = responseJson[@"errmsg"];
                
                [SVProgressHUD showErrorWithStatus:msg];
                
                return;
            } else if ([responseJson[@"data"] isEqual:[NSNull null]]) {
                [SVProgressHUD showErrorWithStatus:@"No more data"];
                return;
            } else{
                NSDictionary *dict = [(NSDictionary *)responseJson[@"data"] mutableCopy];
                NSLog(@"dict:%@", dict);
            }
        });
    } completeFailed:^(NSString *failedStr) {
        [SVProgressHUD showInfoWithStatus:failedStr];
    }];
    
}

- (void)favClick:(id)sender{
    UIButton * favBtn = (UIButton *)sender;
    [favBtn setSelected:![favBtn isSelected]];
}

- (void)cmtClick:(id)sender{
    UIButton * cmtBtn = (UIButton *)sender;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.title = self.profileVideoModel.videoName;
    self.view.backgroundColor = [UIColor colorWithRed:46/256.0 green:46/246.0 blue:46/256.0 alpha:1];
    
    __weak typeof(self)weakSelf = self;
    [self.videoController setDimissCompleteBlock:^{
        [weakSelf.videoController pause];
        weakSelf.videoController = nil;
        // NavigationController pop when _videoController dismiss
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    //    NSURL *videoURL = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
    //    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"hehe" withExtension:@"mov"];
    
    
    NSURL *videoFullPath = [NSURL URLWithString: self.profileVideoModel.videoPath];
    //    NSURL *videoFullPath = [[NSBundle mainBundle] URLForResource:@"hehe" withExtension:@"mov"];
    
    [self playVideoWithURL:videoFullPath];
    
#warning 视频信息
    CGRect rct = _videoController.view.frame;

    UIView *tempory = [[UIView alloc]init];
    tempory.frame = CGRectMake(0, rct.origin.y+rct.size.height, kScreenWidth, kScreenHeight - rct.size.height);
    tempory.backgroundColor = [UIColor colorWithRed:37/256.0 green:37/256.0 blue:37/256.0 alpha:1];
    [self.view addSubview:tempory];
    
    UILabel *vnameLabel = [[UILabel alloc]init];
    vnameLabel.frame = CGRectMake(5, 5, kScreenWidth, 35);
    vnameLabel.text = _profileVideoModel.videoName;
    vnameLabel.font = [UIFont systemFontOfSize:24.0f];
    vnameLabel.textColor = [UIColor colorWithRed:103/256.0 green:146/256.0 blue:106/256.0 alpha:1];
    [tempory addSubview:vnameLabel];
    
    UILabel *timelenLabel = [[UILabel alloc]init];
    timelenLabel.frame = CGRectMake(5, 40, kScreenWidth, 25);
    // timelenLabel.text = _profileVideoModel.timelen;
    timelenLabel.text = @"时长 02:36";
    timelenLabel.font = [UIFont systemFontOfSize:20.0f];
    timelenLabel.textColor = [UIColor colorWithRed:128/256.0 green:128/256.0 blue:128/256.0 alpha:1];
    [tempory addSubview:timelenLabel];
    
    UILabel *uploadTimeLbl = [[UILabel alloc]init];
    uploadTimeLbl.frame = CGRectMake(5, 65, kScreenWidth, 25);
    // uploadTimeLbl.text = _profileVideoModel.timestamp;
    uploadTimeLbl.text = @"发布时间 二个月前";
    uploadTimeLbl.font = [UIFont systemFontOfSize:20.0f];
    uploadTimeLbl.textColor = [UIColor colorWithRed:128/256.0 green:128/256.0 blue:128/256.0 alpha:1];
    [tempory addSubview:uploadTimeLbl];
    
    UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanBtn.frame = CGRectMake(5, 90, 32, 32);
    [zanBtn setBackgroundImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    [zanBtn setBackgroundImage:[UIImage imageNamed:@"zan_sel"] forState:UIControlStateSelected];
    [zanBtn addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempory addSubview:zanBtn];
    
    UILabel *zanLbl = [[UILabel alloc]init];
    zanLbl.frame = CGRectMake(40, 90, 55, 32);
    // zanLbl.text = _profileVideoModel.timestamp;
    zanLbl.text = @"115";
    zanLbl.font = [UIFont systemFontOfSize:20.0f];
    zanLbl.textColor = [UIColor colorWithRed:128/256.0 green:128/256.0 blue:128/256.0 alpha:1];
    [tempory addSubview:zanLbl];
    
    UIButton *favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favBtn.frame = CGRectMake(115, 90, 32, 32);
    [favBtn setBackgroundImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    [favBtn setBackgroundImage:[UIImage imageNamed:@"fav_sel"] forState:UIControlStateSelected];
    [favBtn addTarget:self action:@selector(favClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempory addSubview:favBtn];
    
    UILabel *favLbl = [[UILabel alloc]init];
    favLbl.frame = CGRectMake(150, 90, 55, 32);
    // zanLbl.text = _profileVideoModel.timestamp;
    favLbl.text = @"105";
    favLbl.font = [UIFont systemFontOfSize:20.0f];
    favLbl.textColor = [UIColor colorWithRed:128/256.0 green:128/256.0 blue:128/256.0 alpha:1];
    [tempory addSubview:favLbl];
    
    UIButton *cmtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cmtBtn.frame = CGRectMake(225, 90, 32, 32);
    [cmtBtn setBackgroundImage:[UIImage imageNamed:@"cmt"] forState:UIControlStateNormal];
    [cmtBtn addTarget:self action:@selector(cmtClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempory addSubview:cmtBtn];
    
    UILabel *cmtLbl = [[UILabel alloc]init];
    cmtLbl.frame = CGRectMake(260, 90, 55, 32);
    // zanLbl.text = _profileVideoModel.timestamp;
    cmtLbl.text = @"345";
    cmtLbl.font = [UIFont systemFontOfSize:20.0f];
    cmtLbl.textColor = [UIColor colorWithRed:128/256.0 green:128/256.0 blue:128/256.0 alpha:1];
    [tempory addSubview:cmtLbl];
}

- (KRVideoPlayerController *)videoController{
    if (_videoController == nil) {
        _videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavgationBarHeight, kScreenWidth, kScreenWidth)];
    }
    return _videoController;
}


- (void)playVideoWithURL:(NSURL *)url
{
    self.videoController.contentURL = url;
    [self.videoController showInWindow];
}

- (void)viewWillDisappear:(BOOL)animated{
    //    NSLog(@"%s", __func__);
    // 切换控制器的时候，dismiss 掉 videoController
    [self.videoController pause];
    [self.videoController dismiss];
}




@end

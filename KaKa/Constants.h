//
//  Constants.h
//  KaKa
//
//  Created by yxj on 16/2/24.
//  Copyright © 2016年 yxj. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kStatusBarHeight 20
#define kMagicNumber 44
#define kNavgationBarHeight 44
#define kMagicZero 0

#define kNormalHeight 44
#define kIconW 50
#define kIconH 50
//#define kMainPageTableViewHeigh 667-20-44-60-49
#define kSegementControlHeight 40
#define kTabBarHeight 49
#define kMainPageTableViewHeigh kScreenHeight-kStatusBarHeight-kNavgationBarHeight-kSegementControlHeight-kTabBarHeight
#define kSnapshotWidth (kScreenWidth-1)/2

#define kBtnFont [UIFont systemFontOfSize:15.0f]

#define kLoginServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/login/"
#define kSignupServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/register/"
#define kGetIndexServerAddress @"http://www.linzerlee.cn:8080/kakaweb/mobile/circle/"
#define kVideoServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/get_video_info/"
#define kPathOfVideoInServer @"http://www.linzerlee.cn/kakadata/video/"
#define kAudioServerAddress @"http://www.linzerlee.cn:8080/kakaweb/mobile/get_audio/?page=0-10"

#define kPageSize 2

#define kUsernameKey @"username"
#define kPasswordKey @"password"
#define kMobileKey   @"mobile"

#endif /* Constants_h */

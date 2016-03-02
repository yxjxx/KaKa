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

#define kBtnFont [UIFont systemFontOfSize:15.0f]

#define kLoginServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/login/"
#define kSignupServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/register/"
#define kGetIndexServerAddress @"http://www.linzerlee.cn:8080/kakaweb/mobile/circle/"
#define kVideoServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/get_video_info/"
#define kPathOfVideoInServer @"http://www.linzerlee.cn/kakadata/video/"

#define kPageSize 10

#define kUsernameKey @"username"
#define kPasswordKey @"password"
#define kMobileKey   @"mobile"

#endif /* Constants_h */

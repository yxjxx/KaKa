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

#define kNormalHeight 44
#define kIconW 50
#define kIconH 50

#define kBtnFont [UIFont systemFontOfSize:15.0f]

#define kLoginServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/login/"
#define kSignupServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/register/"

#define kUsernameKey @"username"
#define kPasswordKey @"password"
#define kMobileKey   @"mobile"

#endif /* Constants_h */

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
#define kProfileCollectionViewHeight  kScreenHeight-kStatusBarHeight-kNavgationBarHeight-kTabBarHeight
#define kProfileTopUIViewHeight 120
#define kProfileCollectionViewY kStatusBarHeight+kNavgationBarHeight+kProfileTopUIViewHeight
#define kSnapshotWidth (kScreenWidth-1)/2
#define kSnapshotWidthForProfile (kScreenWidth-2)/3

#define kBtnFont [UIFont systemFontOfSize:15.0f]

#define kLoginServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/login/"
#define kSignupServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/register/"
#define kGetIndexServerAddress @"http://www.linzerlee.cn:8080/kakaweb/mobile/circle/"
#define kVideoServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/get_video_info/"
#define kPathOfVideoInServer @"http://www.linzerlee.cn/kakadata/video/"
#define kAudioServerAddress @"http://www.linzerlee.cn:8080/kakaweb/mobile/get_audio/"
#define kGetPersonalVideoListServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/get_video_info/"
#define kUploadVideoServerAddress @"http://www.linzerlee.cn:8080/kakaweb/upload/video/"
#define kGetUserInfoServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/get_userinfo/"
#define kSetVideoInfoServerAddress @"http://www.linzerlee.cn:8080/kakaweb/home/set_video_info/"

#define kPageSize 6

#define kUsernameKey @"username"
#define kPasswordKey @"password"
#define kMobileKey   @"mobile"

#define kDocumentsPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
/*Like this...
 /Users/yxj/Library/Developer/CoreSimulator/Devices/60DD9105-A013-449A-A21E-4E170BCA105F/data/Containers/Data/Application/D9D3D81E-6DA3-4192-A5A6-86514D4BE0FF/Documents
*/



/* Append By Linzer At 2016/03/01 */
#define VIDEO_PATH @"video"
#define AUDIO_PATH @"audio"
#define SNAPSHOT_PATH @"snapshot"
#define DATA_PATH @"data"
#define AUDIO_LIBRARY @"audio_library.data"
#define VIDEO_LIBRARY @"video_library.data"

#endif /* Constants_h */

//
//  KKOptionsTableVC.m
//  KaKa
//
//  Created by kqy on 3/2/16.
//  Copyright © 2016 yxj. All rights reserved.
//

#import "KKOptionsTableVC.h"
#import <SVProgressHUD.h>
#import "KKLoginViewController.h"
#import "KKSignupViewController.h"
#import "KKMainPageViewController.h"
#import "clearVideoAndAudio.h"
@interface KKOptionsTableVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation KKOptionsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"logBg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     
    NSLog(@"view didload kkoption TableView Cell");
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0: //个人 3个
            switch (row) {
                case 0:

                    
                    break;
                case 1:

                    
                    break;
                case 2:

                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1: //Account 2个
            switch (row) {
                case 0:  //重新注册1个号
                    [self  ReSignUpClick];

                    
                    break;
                case 1: //退出登陆
                    [self loginOutClick];

                    
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 2: //support  清空缓存
            switch (row) {
                case 0://   清空视频缓存

                    [self clearVideoFiles];
                    break;
                case 1: //清空音频文件

                    [self clearAudioFiles];

                    break;
                case 2:  //清空所有文件

                    [self clearAllFiles];

                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 3:

            break;
            
        case 4:

            break;
            
        default:
            break;
    }
}

- (void) ReSignUpClick {
    KKSignupViewController *signUpVc = [[KKSignupViewController alloc]init];
    [self.navigationController pushViewController:signUpVc animated:YES];
}
- (void) loginOutClick {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUsernameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLog"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMobileKey];
    //TODO: 向服务端发送logout请求
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:0];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2){
        return 3;
    } else if (section == 3){
        return 2;
    } else   {
        return 4;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"修改昵称";
        }else if (indexPath.row ==1){
            cell.textLabel.text = @"修改密码";
        }
        else {
            cell.textLabel.text = @"改其头像";
        }
    } else  if( indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"重新注册一个号";
        } else if(indexPath.row ==1){
            cell.textLabel.text = @"退出登陆";
        }
    }else if (indexPath.section == 2){//group 3,section = 2
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清空视频缓存";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"清空音频文件";
        } else {
            cell.textLabel.text = @"清空所有文件";
        }
        
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我要提意见";
        } else {
            cell.textLabel.text = @"查看当前版本";
        }
    }  else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Linked Accounts";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Push"; //Notification Settings
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Cellular Data Use";
        } else {
            cell.textLabel.text = @"Save Original Photos";
        }
    }
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"个人";
    } else if(section ==1) {
        return @"Account";
    } else if (section == 2){
        return @"Support";
    } else if (section == 3) {
        return @"About";
    } else {
        return @"Setting";
    }
}

- (void) testSetBackColor {
    
    //method 1
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"KaBackground" ]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];   //(1)
    self.tableView.opaque = NO; //(2) (1,2)两行不要也行，背景图片也能显示
    self.tableView.backgroundView = imageView;
    
}


//清空视频文件
- (void)  clearVideoFiles {

    NSString *documentsPath =[self dirDoc];
   NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *videoDirectory1 = [documentsPath stringByAppendingPathComponent:@"video"];
    NSString *videoDirectory2 = [documentsPath stringByAppendingPathComponent:@"snapshot"];
    
    for (NSString *videoFileA in videoDirectory1) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSString *absolutePath=[documentsPath stringByAppendingPathComponent:videoFileA];
        [fileManager removeItemAtPath:absolutePath error:nil];
    }
    
    for (NSString *videoFileB in videoDirectory2) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSString *absolutePath=[documentsPath stringByAppendingPathComponent:videoFileB];
        [fileManager removeItemAtPath:absolutePath error:nil];
    }
    
    
    BOOL res=[fileManager removeItemAtPath:videoDirectory1 error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    }else
        NSLog(@"文件删除失败");
    //TODO:  视频在2个地方
    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:videoDirectory1]?@"YES":@"NO");

}
//清空音频文件
- (void) clearAudioFiles {
     NSString *documentsPath =[self dirDoc];
     NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *audioDirectory1 = [documentsPath stringByAppendingPathComponent:@"audio"];
    NSString *audioDirectory2 = [documentsPath stringByAppendingPathComponent:@"data"];
    
    for (NSString *audioFileA in audioDirectory1) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSString *absolutePath=[documentsPath stringByAppendingPathComponent:audioFileA];
        [fileManager removeItemAtPath:absolutePath error:nil];
    }
    
    for (NSString *audioFileB in audioDirectory2) {
        //如有需要，加入条件，过滤掉不想删除的文件
        NSString *absolutePath=[documentsPath stringByAppendingPathComponent:audioFileB];
        [fileManager removeItemAtPath:absolutePath error:nil];
    }
    
    
    BOOL res=[fileManager removeItemAtPath:audioDirectory1 error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    }else
        NSLog(@"文件删除失败");
    //TODO:  音频在2个地方
    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:audioDirectory1]?@"YES":@"NO");
    
    
}

  //TODO: 清空所有文件
- (void) clearAllFiles{
    
}
//+(void)clearCache:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtPath:absolutePath error:nil];
//        }
//    }
//    [[SDImageCache sharedImageCache] cleanDisk];
//}

//删除文件
-(void)deleteFile{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    BOOL res=[fileManager removeItemAtPath:testPath error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    }else
        NSLog(@"文件删除失败");
    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:testPath]?@"YES":@"NO");
}

//获取Documents目录
-(NSString *)dirDoc{
    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}
//获取Library目录
-(void)dirLib{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_lib: %@",libraryDirectory);
}

//获取Cache目录
-(void)dirCache{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSLog(@"app_home_lib_cache: %@",cachePath);
}
//获取Tmp目录
-(void)dirTmp{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSLog(@"app_home_tmp: %@",tmpDirectory);
}




//获取应用沙盒根路径
-(void)dirHome{
    NSString *dirHome=NSHomeDirectory();
    NSLog(@"app_home: %@",dirHome);
}
@end

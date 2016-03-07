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

#import "SDImageCache.h"
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
                    NSLog(@" 1-1 section:%ld,row:%ld",section,row);
                    
                    break;
                case 1:
                    NSLog(@" 1-2 section:%ld,row:%ld",section,row);
                    
                    break;
                case 2:
                    NSLog(@" 1-3 section:%ld,row:%ld",section,row);
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1: //Account 2个
            switch (row) {
                case 0:  //重新注册1个号
                    [self  ReSignUpClick];
                    // NSLog(@" 2-1 section:%d,row:%d",section,row);
                    
                    break;
                case 1: //退出登陆
                    [self loginOutClick];
                    // NSLog(@" 2-2 section:%d,row:%d",section,row);
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 2: //support  清空缓存
            switch (row) {
                case 0:
                    NSLog(@" 3-1 section:%ld,row:%ld",section,row);
                    
                    break;
                case 1:
                    NSLog(@" 3-2 section:%ld,row:%ld",section,row);
                    
                    break;
                case 2:
                    NSLog(@" 3-3 section:%ld,row:%ld",section,row);
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 3:
            NSLog(@"section:%ld,row:%ld",section,row);
            break;
            
        case 4:
            NSLog(@"section:%ld,row:%ld",section,row);
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
            cell.textLabel.text = @"清空缓存";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"清空我音频文件";
        } else {
            cell.textLabel.text = @"清空历史记录";
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
    
    /*method 2   method2 */
    
    //method 1
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"KaBackground" ]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];   //(1)
    self.tableView.opaque = NO; //(2) (1,2)两行不要也行，背景图片也能显示
    self.tableView.backgroundView = imageView;
    
}



/*method 1
//计算单个文件大小
+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算目录大小
+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[FileService fileSizeAtPath:absolutePath];
        }
        　　　　　//SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

//清理缓存文件
+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
 method 1
 */
@end

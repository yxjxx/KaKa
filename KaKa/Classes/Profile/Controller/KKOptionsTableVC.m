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
    self.tableView.separatorColor = [UIColor colorWithRed:100/256.0 green:100/256.0 blue:100/256.0 alpha:0.5];

    self.tableView.backgroundColor =  [UIColor colorWithRed:30/256.0 green:30/256.0 blue:30/256.0 alpha:1];
    
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
    cell.backgroundColor = [UIColor colorWithRed:45/256.0 green:45/256.0 blue:45/256.0 alpha:1];

    cell.textLabel.textColor  = [UIColor colorWithRed:110/256.0 green:110/256.0 blue:117/256.0 alpha:1];

    //被选中的color:
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithRed:30/256.0 green:30/256.0 blue:30/256.0 alpha:1];
                              
                              
                              
    cell.selectedBackgroundView = bgView;
    
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
            cell.textLabel.text = @"检查更新";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"去评分"; //Notification Settings
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"推荐给好友";
        } else {
            cell.textLabel.text = @"我要赞助";
        }
    }
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"个人信息";
    } else if(section ==1) {
        return @"帐号";
    } else if (section == 2){
        return @"清理空间";
    } else if (section == 3) {
        return @"关于";
    } else {
        return @"设置";
    }
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
//    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:videoDirectory1]?@"YES":@"NO");

}
//清空音频文件
- (void) clearAudioFiles {
    
    
}
- (void) clearAllFiles {
    
}


-(NSString *)dirDoc{
     [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}


@end

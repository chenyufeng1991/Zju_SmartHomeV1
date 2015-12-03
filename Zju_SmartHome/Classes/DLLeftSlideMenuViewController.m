//
//  DLLeftSlideMenuViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLeftSlideMenuViewController.h"
#import "MBProgressHUD+MJ.h"
#import "JYLoginViewController.h"
#import "JYChangePwdViewController.h"

#define MAX_CENTER_X [[UIScreen mainScreen] bounds].size.width
#define LINE_COLOR [UIColor colorWithRed:0.892 green:0.623 blue:0.473 alpha:0.5]

@implementation DLLeftSlideMenuViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    CGRect screen = [[UIScreen mainScreen] bounds];
    float centerX = screen.size.width / 2;
    self.view.backgroundColor = [UIColor colorWithRed:0.224 green:0.231 blue:0.278 alpha:0.8];

    
    //头像图片
    UIImageView *userPhoto = [[UIImageView alloc]init];
    userPhoto.image = [UIImage imageNamed:@"UserPhoto.jpg"];
    userPhoto.frame = CGRectMake(0, 0, 80, 80);
    userPhoto.center = CGPointMake((MAX_CENTER_X - centerX) * 3 / 5 , 80);
    [self.view addSubview:userPhoto];
    
    //头像下的名字
    UILabel *lblName = [[UILabel alloc]init];
    lblName.text = @"Paul Walker";
    lblName.font = [UIFont systemFontOfSize:12 weight:UIFontWeightUltraLight];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.textColor = [UIColor whiteColor];
    CGFloat lblNameX = CGRectGetMinX(userPhoto.frame);
    CGFloat lblNameY = CGRectGetMaxY(userPhoto.frame) + 10;
    CGFloat lblNameW = userPhoto.frame.size.width;
    CGFloat lblNameH = 20;
    lblName.frame = CGRectMake(lblNameX, lblNameY, lblNameW, lblNameH);
    [self.view addSubview:lblName];
    
    /**
     *  先统一设置frame的一些值
     */
    CGFloat belowBtnX = CGRectGetMinX(userPhoto.frame);
    CGFloat belowBtnW = userPhoto.frame.size.width;
    CGFloat belowBtnH = 30;
    
    CGFloat lineX = CGRectGetMinX(userPhoto.frame) - 10;
    CGFloat lineW = userPhoto.frame.size.width + 20;
    CGFloat lineH = 1;
    
    //更换头像按钮
    UIButton *btnChangePhoto = [self belowButtonsWithTitle:@"更换头像"];
    CGFloat btnChangePhotoY = screen.size.height * 6 / 17;
    btnChangePhoto.frame = CGRectMake(belowBtnX, btnChangePhotoY, belowBtnW, belowBtnH);
    [self.view addSubview:btnChangePhoto];
    [btnChangePhoto addTarget:self action:@selector(btnChangePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc]init];
    CGFloat line1Y = CGRectGetMaxY(btnChangePhoto.frame) + 10;
    line1.frame = CGRectMake(lineX, line1Y, lineW, lineH);
    line1.backgroundColor = LINE_COLOR;
    [self.view addSubview:line1];
    
    //完善资料按钮
    UIButton *btnCompleteProfile = [self belowButtonsWithTitle:@"完善资料"];
    CGFloat btnCompleteProfileY = screen.size.height * 8 / 17;
    btnCompleteProfile.frame = CGRectMake(belowBtnX, btnCompleteProfileY, belowBtnW, belowBtnH);
    [self.view addSubview:btnCompleteProfile];
    [btnCompleteProfile addTarget:self action:@selector(btnCompleteProfileClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line2 = [[UIView alloc]init];
    CGFloat line2Y = CGRectGetMaxY(btnCompleteProfile.frame) + 10;
    line2.frame = CGRectMake(lineX, line2Y, lineW, lineH);
    line2.backgroundColor = LINE_COLOR;
    [self.view addSubview:line2];
    
    //修改密码按钮
    UIButton *btnModifyPassWord = [self belowButtonsWithTitle:@"修改密码"];
    CGFloat btnModifyPassWordY = screen.size.height * 10 / 17;
    btnModifyPassWord.frame = CGRectMake(belowBtnX, btnModifyPassWordY, belowBtnW, belowBtnH);
    [self.view addSubview:btnModifyPassWord];
    [btnModifyPassWord addTarget:self action:@selector(btnModifyPassWordClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line3 = [[UIView alloc]init];
    CGFloat line3Y = CGRectGetMaxY(btnModifyPassWord.frame) + 10;
    line3.frame = CGRectMake(lineX, line3Y, lineW, lineH);
    line3.backgroundColor = LINE_COLOR;
    [self.view addSubview:line3];
    
    //修改邮箱按钮
    UIButton *btnModifyEmail = [self belowButtonsWithTitle:@"修改邮箱"];
    CGFloat btnModifyEmailY = screen.size.height * 12 / 17;
    btnModifyEmail.frame = CGRectMake(belowBtnX, btnModifyEmailY, belowBtnW, belowBtnH);
    [self.view addSubview:btnModifyEmail];
    [btnModifyEmail addTarget:self action:@selector(btnModifyEmailClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line4 = [[UIView alloc]init];
    CGFloat line4Y = CGRectGetMaxY(btnModifyEmail.frame) + 10;
    line4.frame = CGRectMake(lineX, line4Y, lineW, lineH);
    line4.backgroundColor = LINE_COLOR;
    [self.view addSubview:line4];
    
    //账号注销按钮
    UIButton *btnAccountLogout = [self belowButtonsWithTitle:@"账号注销"];
    CGFloat btnAccountLogoutY = screen.size.height * 14 / 17;
    btnAccountLogout.frame = CGRectMake(belowBtnX, btnAccountLogoutY, belowBtnW, belowBtnH);
    [self.view addSubview:btnAccountLogout];
    [btnAccountLogout addTarget:self action:@selector(btnAccountLogoutClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line5 = [[UIView alloc]init];
    CGFloat line5Y = CGRectGetMaxY(btnAccountLogout.frame) + 10;
    line5.frame = CGRectMake(lineX, line5Y, lineW, lineH);
    line5.backgroundColor = LINE_COLOR;
    [self.view addSubview:line5];
}


- (UIButton *)belowButtonsWithTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightUltraLight];
    return btn;
}


- (void)btnChangePhotoClick{
    
}

- (void)btnCompleteProfileClick{
    
}

- (void)btnModifyPassWordClick
{
    JYChangePwdViewController *changePwd=[[JYChangePwdViewController alloc]init];
    [self.navigationController pushViewController:changePwd animated:YES];
}

- (void)btnModifyEmailClick{
    
}

- (void)btnAccountLogoutClick
{
    //创建UIAlertView控件
    UIAlertView *logoutAlert=[[UIAlertView alloc]
                              initWithTitle:@"注销当前账号"//指定标题
                              message:@"注销当前账号需要重新登录"//指定消息
                              delegate:self//指定委托对象
                              cancelButtonTitle:@"取消"//为底部的取消按钮设置标题
                              otherButtonTitles:@"确定", nil];
    [logoutAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        //沙盒路径
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *file=[doc stringByAppendingPathComponent:@"account.data"];
        
        //清空沙盒内容
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtPath:file error:nil];
        
        self.view.window.rootViewController=[[JYLoginViewController alloc]init];
    }
    else
    {
        
    }
}
@end

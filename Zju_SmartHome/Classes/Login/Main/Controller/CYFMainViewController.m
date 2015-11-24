//
//  CYFMainViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFMainViewController.h"
#import "JYMainView.h"
#import "CYFFurnitureViewController.h"
#import "RESideMenu.h"
@interface CYFMainViewController ()<JYMainViewDelegate>

@end

@implementation CYFMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置显示的view
    JYMainView *jyMainView=[JYMainView mainViewXib];
    //设置代理
    jyMainView.delegate=self;
    self.view =jyMainView;
    
    //设置导航栏
    [self setupNavgationItem];
}

//设置导航栏
-(void)setupNavgationItem
{
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"IQUP"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
    
    UIButton *leftBtn=[[UIButton alloc]init];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"UserPhoto"] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(0, 0, 28, 28);
    [leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

//左边头像点击事件
-(void)leftPortraitClick
{
    
}

//代理方法
-(void)furnitureClick
{
    CYFFurnitureViewController *jyVc=[[CYFFurnitureViewController alloc]init];
    [self.navigationController pushViewController:jyVc animated:YES];
}

@end

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

#import "HttpRequest.h"
#import "InternalGateIPXMLParser.h"
#import "AppDelegate.h"

#import "AllUtils.h"
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
  
  
  //获取内网IP
  [HttpRequest getInternalNetworkGateIP:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"获取内网返回的数据：%@",result);
    
    //并直接在这里进行解析；
    InternalGateIPXMLParser *parser = [[InternalGateIPXMLParser alloc] initWithXMLString:result];
    NSLog(@"解析返回：%@",parser.internalIP);
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.globalInternalIP = parser.internalIP;
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"获取内网返回数据失败：%@",error);
  }];
  
  
}


#pragma mark - 弹出对话框让用户选择网络
- (void)viewDidAppear:(BOOL)animated{

  [super viewDidAppear:animated];
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  [AllUtils showPromptDialog:@"提示" andMessage:@"请选择网络环境" OKButton:@"外部网络" OKButtonAction:^(UIAlertAction *action) {
      //外网；
    app.isInternalNetworkGate = false;
    NSLog(@"你选择了外网");

  } cancelButton:@"内部网络" cancelButtonAction:^(UIAlertAction *action) {
      
     //内网；
    app.isInternalNetworkGate = true;
    NSLog(@"你选择了内网");

    
    
  } contextViewController:self];
  
  
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

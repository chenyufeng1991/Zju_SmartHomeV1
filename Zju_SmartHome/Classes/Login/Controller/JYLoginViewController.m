//
//  JYLoginViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/10/31.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYLoginViewController.h"
#import "JYLoginXib.h"
#import "JYRegisterViewController.h"
#import "JYNavigationController.h"
#import "AFNetworking.h"
#import "JYLoginStatus.h"
#import "JYUserData.h"
#import "MBProgressHUD+MJ.h"
#import "CYFMainViewController.h"
#import "JYNavigationController.h"
#import "RegViewController.h"
#import "RESideMenu.h"
#import "DLLeftSlideMenuViewController.h"

#import "Reachability.h"

@interface JYLoginViewController ()<LoginXibDelegate,UITextFieldDelegate>

@property(nonatomic,strong)JYLoginXib *loginXib;

@property(nonatomic,assign) BOOL isConnectNetworking;


@property(nonatomic,assign) BOOL isFirstShowAlertDialog;



@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation JYLoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  JYLoginXib *loginXib=[JYLoginXib loginXib];
  //设置代理
  loginXib.delegate=self;
  self.loginXib=loginXib;
  //设置文本输入框的代理
  loginXib.password.delegate=self;
  loginXib.username.delegate=self;
  self.view=loginXib;
  
  
  
  //下面是与网络判断有关的；
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
  
  NSString *remoteHostName = @"http://www.baidu.com";
  
  self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
  [self.hostReachability startNotifier];
  [self updateInterfaceWithReachability:self.hostReachability];
  
  self.internetReachability = [Reachability reachabilityForInternetConnection];
  [self.internetReachability startNotifier];
  [self updateInterfaceWithReachability:self.internetReachability];
  
  self.wifiReachability = [Reachability reachabilityForLocalWiFi];
  [self.wifiReachability startNotifier];
  [self updateInterfaceWithReachability:self.wifiReachability];
  
  
  self.isConnectNetworking = false;
  self.isFirstShowAlertDialog = true;
  
}


//UITextField监听事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  if([textField.text isEqualToString:@"请输入用户名"])
  {
    [textField setText:@""];
  }
  else if([textField.text isEqualToString:@"请输入密码"])
  {
    self.loginXib.eyePicture.hidden=NO;
    [textField setText:@""];
    //textField.font=[UIFont systemFontOfSize:10];
    textField.secureTextEntry=YES;
  }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

//代理登录方法
-(void)loginGoGoGo:(NSString *)username and:(NSString *)password
{
  
  
  if (self.isConnectNetworking) {
    //连接网络；
    
    //    //显示一个蒙板
    [MBProgressHUD showMessage:@"正在登录中..."];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    [mgr setSecurityPolicy:securityPolicy];
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"account"]=username;
    params[@"password"]=password;
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Passport/dologin" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)

    {
        //请求成功
        JYLoginStatus *status=[JYLoginStatus statusWithDict:responseObject];
        
        JYUserData *data=status.data;
        
        //5.存储模型数据
        //归档
//        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        NSString *file=[doc stringByAppendingPathComponent:@"account.data"];
//        [NSKeyedArchiver archiveRootObject:data toFile:file];
        
        if([status.code isEqualToString:@"0"])
        {
            //移除遮盖
            [MBProgressHUD hideHUD];
            DLLeftSlideMenuViewController *leftSlideMenuViewController = [[DLLeftSlideMenuViewController alloc] init];
            CYFMainViewController *cyfVc=[[CYFMainViewController alloc]init];
            
            JYNavigationController *navVc=[[JYNavigationController alloc]initWithRootViewController:cyfVc];
            RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navVc
                                                                            leftMenuViewController:leftSlideMenuViewController
                                                                           rightMenuViewController:nil];
            JYNavigationController *navVc1=[[JYNavigationController alloc]initWithRootViewController:sideMenuViewController];
            navVc1.navigationBar.hidden=YES;
            self.view.window.rootViewController=navVc1;
            //[self.navigationController pushViewController:navVc1 animated:YES];

        }
        else if([status.code isEqualToString:@"330"])
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"用户名或者密码错误"];
        }
        else if([status.code isEqualToString:@"308"])
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"用户名活着邮箱重复"];
          
        }
        else if([status.code isEqualToString:@"300"])
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"没有登录"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"登录请求失败"];

    }];
    
    
    
  }
  
}

//代理忘记密码方法
- (void)forgetPasswordGO{
  RegViewController* reg = [[RegViewController alloc] init];
  [self presentViewController:reg animated:YES completion:^{
    
  }];
}

//代理注册方法
-(void)registerGoGoGo
{
  JYRegisterViewController *registerVc=[[JYRegisterViewController alloc]init];
  //JYNavigationController *navVc=[[JYNavigationController alloc]initWithRootViewController:registerVc];
  self.view.window.rootViewController=registerVc;
  //[self.navigationController pushViewController:navVc animated:YES];
  
  
}

#pragma mark - 判断是否联网

- (void) reachabilityChanged:(NSNotification *)note
{
  Reachability* curReach = [note object];
//  NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
  [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
  if (reachability == self.hostReachability)
  {
    [self configureTextField: reachability];
    
    
  }
  
  if (reachability == self.internetReachability)
  {
    [self configureTextField: reachability];
  }
  
  if (reachability == self.wifiReachability)
  {
    [self configureTextField:reachability];
  }
}


- (void)configureTextField:(Reachability *)reachability
{
  NetworkStatus netStatus = [reachability currentReachabilityStatus];
  BOOL connectionRequired = [reachability connectionRequired];
  
  switch (netStatus)
  {
    case NotReachable:
    {
      
      NSLog(@"网络不可用");
      self.isConnectNetworking = false;
      
      connectionRequired = NO;
      
       NSLog(@"布尔值1：%d",self.isFirstShowAlertDialog);
      
      if (!self.isFirstShowAlertDialog) {

         NSLog(@"布尔值2：%d",self.isFirstShowAlertDialog);
        
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未连接网络，请确定后再试"
                                                     delegate:self
                                            cancelButtonTitle:@"提示" otherButtonTitles:nil];
      
      
      [alert show];

        self.isFirstShowAlertDialog = !self.isFirstShowAlertDialog;
         NSLog(@"布尔值3：%d",self.isFirstShowAlertDialog);
      }
    
      break;
    }
      
    case ReachableViaWWAN:
    {
      NSLog(@"连接WWAN");
      self.isConnectNetworking = true;
      
      
      if (!self.isFirstShowAlertDialog) {
        self.isFirstShowAlertDialog = !self.isFirstShowAlertDialog;
      }
      
      break;
    }
    case ReachableViaWiFi:
    {
      
      NSLog(@"当前连接了WiFi");
      self.isConnectNetworking = true;
      
      
      if (!self.isFirstShowAlertDialog) {
        self.isFirstShowAlertDialog = !self.isFirstShowAlertDialog;
      }
      
      break;
    }
  }//switch；
  
}


- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}



@end

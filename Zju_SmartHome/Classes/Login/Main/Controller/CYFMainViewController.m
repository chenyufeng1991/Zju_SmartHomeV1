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
#import <CoreLocation/CoreLocation.h>
@interface CYFMainViewController ()<JYMainViewDelegate,CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager* locationManager;

@property(nonatomic,strong) JYMainView *mainView;

@end

@implementation CYFMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //设置显示的view
  JYMainView *jyMainView=[JYMainView mainViewXib];
  //设置代理
  jyMainView.delegate=self;
  self.mainView = jyMainView;
  self.view =jyMainView;
  
  //设置导航栏
  [self setupNavgationItem];
  
  [self testOpenLocationFunction];
  
  
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

#pragma mark - 检测定位功能是否开启
- (void)testOpenLocationFunction{

  //检测定位功能是否开启
  if([CLLocationManager locationServicesEnabled]){
    
    if(!_locationManager){
      
      self.locationManager = [[CLLocationManager alloc] init];
      
      if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        
      }
      
      //设置代理
      [self.locationManager setDelegate:self];
      //设置定位精度
      [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
      //设置距离筛选
      [self.locationManager setDistanceFilter:100];
      //开始定位
      [self.locationManager startUpdatingLocation];
      //设置开始识别方向
      [self.locationManager startUpdatingHeading];
      
    }
    
  }else{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"您没有开启定位功能"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
    [alertView show];
  }

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

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  [self.locationManager stopUpdatingLocation];
  CLLocation* location = locations.lastObject;
  
  [self reverseGeocoder:location];
}


#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
  
  CLGeocoder* geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    
    if(error || placemarks.count == 0){
      NSLog(@"error = %@",error);
    }else{
      
      CLPlacemark* placemark = placemarks.firstObject;
      NSLog(@"城市:%@",[[placemark addressDictionary] objectForKey:@"City"]);
      NSLog(@"国家:%@",[[placemark addressDictionary] objectForKey:@"Country"]);
      
      NSString *city = [[placemark addressDictionary] objectForKey:@"City"];
      NSString *country = [[placemark addressDictionary] objectForKey:@"Country"];
      
      
      self.mainView.cityLabel.text = city;
      self.mainView.countryLabel.text = country;
      
      
//      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你的位置" message:[[placemark addressDictionary] objectForKey:@"City"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//      
//      [alert show];
      
    }
    
  }];
}

@end

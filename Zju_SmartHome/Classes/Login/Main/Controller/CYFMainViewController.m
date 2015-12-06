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
#import "MBProgressHUD+MJ.h"
#import <CoreLocation/CoreLocation.h>

#import "CYFImageStore.h"

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
    
  jyMainView.officeLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *officeTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(officeLabelTap)];
  [jyMainView.officeLabel addGestureRecognizer:officeTap];
    
  jyMainView.furnitureLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *furnitureTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(furnitureTap)];
  [jyMainView.furnitureLabel addGestureRecognizer:furnitureTap];
    
  jyMainView.productLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *productTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productTap)];
  [jyMainView.productLabel addGestureRecognizer:productTap];
    
  jyMainView.customLabel.userInteractionEnabled=YES;
  UITapGestureRecognizer *customTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customTap)];
  [jyMainView.customLabel addGestureRecognizer:customTap];

    
    
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
    //NSLog(@"获取内网返回的数据：%@",result);
    
    //并直接在这里进行解析；
    InternalGateIPXMLParser *parser = [[InternalGateIPXMLParser alloc] initWithXMLString:result];
   // NSLog(@"解析返回：%@",parser.internalIP);
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.globalInternalIP = parser.internalIP;
    
//    NSLog(@"现在全局的IP是：%@",app.globalInternalIP);
    
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
  
  //设置用户头像；
  
  
  [leftBtn setBackgroundImage:[[CYFImageStore sharedStore] imageForKey:@"CYFStore"] forState:UIControlStateNormal];
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
//家居
-(void)furnitureClick
{
  CYFFurnitureViewController *jyVc=[[CYFFurnitureViewController alloc]init];
  [self.navigationController pushViewController:jyVc animated:YES];
}
//办公室
-(void)officeClick
{
     [MBProgressHUD showError:@"办公室功能尚未开通"];
}
//单品
-(void)productClick
{
    [MBProgressHUD showError:@"单品功能尚未开通"];
}
//自定义
-(void)customClick
{
    [MBProgressHUD showError:@"自定义功能尚未开通"];
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

-(void)officeLabelTap
{
    [MBProgressHUD showError:@"办公室功能尚未开通"];
}
-(void)furnitureTap
{
    CYFFurnitureViewController *jyVc=[[CYFFurnitureViewController alloc]init];
    [self.navigationController pushViewController:jyVc animated:YES];
}
-(void)productTap
{
    [MBProgressHUD showError:@"单品功能尚未开通"];
}
-(void)customTap
{
    [MBProgressHUD showError:@"自定义功能尚未开通"];
}
@end

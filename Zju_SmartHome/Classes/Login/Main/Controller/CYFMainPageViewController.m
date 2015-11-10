//
//  CYFMainPageViewController.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/8.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFMainPageViewController.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import "DLLeftSlideViewController.h"

#define MAX_CENTER_X 420
#define BOUND_X 280

@interface CYFMainPageViewController ()<CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;//设置顶部背景图片的View；
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, strong) CLLocationManager* locationManager;


@property (strong, nonatomic)NSMutableArray *dataMArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CYFMainPageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGRect screen = [[UIScreen mainScreen] bounds];
  centerX = screen.size.width / 2;
  centerY = screen.size.height / 2;
  [self loadTopBackgroundImage];
  [self laodCityBackgroundImage];
  [self.avatarImageView setImage:[UIImage imageNamed:@"avatar"]];
  
  //为了获取城市名称，首先从NSUSerDefaults中获取（上一次的城市名），再从CoreLocation中获取（这一次的城市名）；
  NSString *city = [self getCityNameFromUserDefault];
  if (city != nil) {
    [self.cityLabel setText:city];
  }
  
  [self setCityName];
  
    UIButton *userPhotoBtn = [[UIButton alloc] init];
    userPhotoBtn.frame = self.avatarImageView.frame;
    [userPhotoBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userPhotoBtn];
    
    UIPanGestureRecognizer *avatarTap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:avatarTap];

  //注意下面这句话很重要，需要把cell注册到collectionView中；
  [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionCell"];
  [self setUpCollection];
  
}

-(void) handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    float x = self.view.center.x + translation.x;
    if (x < centerX) {
        x = centerX;
    }
    self.view.center = CGPointMake(x, centerY);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.2 animations:^(void){
            
            if (x > BOUND_X) {
                self.view.center = CGPointMake(MAX_CENTER_X, centerY);
            }else{
                self.view.center = CGPointMake(centerX, centerY);
            }
        }];
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)buttonPressed:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^(void){
        if (self.view.center.x == centerX) {
            self.view.center = CGPointMake(MAX_CENTER_X, centerY);
        }else if (self.view.center.x == MAX_CENTER_X){
            self.view.center = CGPointMake(centerX, centerY);
        }
    }];
}

-(void)setUpCollection{
  self.dataMArr = [NSMutableArray array];
  for(NSInteger index = 0;index<4; index++){
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)index+1]];
    NSDictionary *dic = @{@"image": image};
    [self.dataMArr addObject:dic];
  }
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  
  //否则是黑色的；
  self.collectionView.backgroundColor = [UIColor whiteColor];
}



- (void)clickHotelImage{
  
  [self showPromptDialog:@"提示" andMessage:@"您点击了酒店按钮" andButton:@"确定" andAction:^(UIAlertAction *action) {
    //点击了确定按钮后的响应事件；
    NSLog(@"您点击了确定按钮");
  }];
  
}

- (void)clickAvatarImage{
  
  [self showPromptDialog:@"提示" andMessage:@"这里会弹出侧拉菜单" andButton:@"确定" andAction:^(UIAlertAction *action) {
    //点击了确定按钮后的响应事件；
    NSLog(@"您点击了头像按钮");
      NSLog(@"继续添加");
  }];
}


#pragma mark - 弹出提示对话框
- (void)showPromptDialog:(NSString*)title andMessage:(NSString*)message andButton:(NSString*)buttonTitle andAction:(void (^ __nullable)(UIAlertAction *action)) handler{
  
  //尝试使用新的弹出对话框；
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:handler]];
  //弹出提示框；
  [self presentViewController:alertController animated:true completion:nil];
}



#pragma mark - 加载各种图片
- (void) loadTopBackgroundImage{
  
  UIColor *topBgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topimage.png"]];
  [self.topBackgroundView setBackgroundColor:topBgColor];
}


- (void) laodCityBackgroundImage{
  
  NSLog(@"加载城市图片");
  
  NSURL *imageURL = [[NSURL alloc] initWithString:@"http://www.fansimg.com/uploads2010/10/userid228895time20101022020424.jpg"];
  [self.cityImageView sd_setImageWithURL:imageURL];
}


#pragma mark - 开始进行定位
- (void) setCityName{
  
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
    
    //尝试使用新的弹出对话框；
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alertController animated:true completion:nil];
    
  }
  
}

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  [self.locationManager stopUpdatingLocation];
  CLLocation* location = locations.lastObject;
  
  [self reverseGeocoder:location];
}


#pragma mark - 反向地理编码
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
  
  CLGeocoder* geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    
    if(error || placemarks.count == 0){
      NSLog(@"error = %@",error);
    }else{
      
      CLPlacemark* placemark = placemarks.firstObject;
      //获取当前的城市名称；
      NSString *citySource = [[placemark addressDictionary] objectForKey:@"City"];
      
      //输出当前的城市名称；
      NSLog(@"placemark:%@",citySource);
      
      //删除“市”；
      NSString *cityNow = [citySource substringToIndex:[citySource length]-1];
      NSLog(@"当前的城市是 = %@",cityNow);
      
      //把当前这个城市存储到NSUSerDefaults中；
      [self setCityNameToUserDefault:cityNow];
      
      //设置到Label中；
      [self.cityLabel setText:cityNow];
      
    }
    
  }];
}


#pragma mark - 从NSUserDefaults存储读取城市名
//把城市名称暂时存储到用户首选项(NSUserDefault)中.
- (void)setCityNameToUserDefault:(NSString*)cityName{
  
  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
  [userDefault setObject:cityName forKey:@"CITY"];
  
}

- (NSString*)getCityNameFromUserDefault{
  
  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
  NSString *cityName = [ userDefault objectForKey:@"CITY"];
  return cityName;
  
}



#pragma mark - UICollectionViewDataSource

//以下两个方法是必须实现的2个代理方法；
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.dataMArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *collectionCellID = @"myCollectionCell";
  
  CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
  
  NSDictionary *dic    = self.dataMArr[indexPath.row];
  UIImage *image       = dic[@"image"];
  
  cell.imageView.image = image;
  
  return cell;
};

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  
  //默认为1；
  return 1;
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
  NSLog(@"当前点击的是：%ld",(long)indexPath.row);
}




#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  //这里其实是设置每一个cell的大小，可以根据界面大小来计算；
  return CGSizeMake((DeviceWidth-80)/2, (DeviceWidth-80)/2);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
  return UIEdgeInsetsMake(10, 30, 10, 30);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
  
  return 30;
  
}


//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//  return UIStatusBarStyleLightContent;
//}



@end

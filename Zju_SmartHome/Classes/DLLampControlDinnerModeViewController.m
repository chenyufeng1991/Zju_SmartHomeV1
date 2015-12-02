//
//  DLLampControlDinnerModeViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/11/28.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControlDinnerModeViewController.h"
#import "AFNetworking.h"

#import "AppDelegate.h"

@interface DLLampControlDinnerModeViewController ()
@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UILabel *rValue;
@property (weak, nonatomic) IBOutlet UILabel *gValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;

@property (weak, nonatomic) IBOutlet UIView *colorPreview;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, assign) CGPoint *touchPoint;

@end

@implementation DLLampControlDinnerModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"00000 %@",self.logic_id);
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.tag = 10086;
    UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
    viewColorPickerPositionIndicator.tag = 10087;
    UIButton *btnPlay = [[UIButton alloc] init];
    
    
    
    if (fabsf(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
        //        imgView.image = [UIImage imageNamed:@"circle_5"];
        //        viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
        //        viewColorPickerPositionIndicator.layer.cornerRadius = 8;
        //        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        //        btnPlay.frame = CGRectMake(111, 111, 60, 60);
    }
    if (fabsf(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        imgView.image = [UIImage imageNamed:@"circle_5"];
        viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
        viewColorPickerPositionIndicator.layer.cornerRadius = 8;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(111, 111, 60, 60);
        
    }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        imgView.image = [UIImage imageNamed:@"circle_6"];
        viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
        viewColorPickerPositionIndicator.layer.cornerRadius = 10;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(135, 135, 60, 60);
        
    }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        imgView.image = [UIImage imageNamed:@"circle_6p"];
        viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
        viewColorPickerPositionIndicator.layer.cornerRadius = 12;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(150, 150, 60, 60);
        
    }
    
    if (fabsf(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        //4 & 4s 的时候特判
        //        imgView.frame = CGRectMake(30.0f, 30.0f, imgView.image.size.width, imgView.image.size.height);
    }else {
        imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
    }
    
    imgView.userInteractionEnabled = YES;
    _imgView = imgView;
    
    viewColorPickerPositionIndicator.backgroundColor = [UIColor colorWithRed:0.678 green:0.169 blue:0.710 alpha:1.000];
    
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"ct_icon_buttonbreak-off"] forState:UIControlStateNormal];
    
    [self.panelView addSubview:imgView];
    [self.panelView addSubview:viewColorPickerPositionIndicator];
    [self.panelView addSubview:btnPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


/**
 *  判断点触位置，如果点触位置在颜色区域内的话，才返回点触的控件为UIImageView *imgView
 *  除此之外，点触位置落在小圆内部或者大圆外部，都返回nil
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = nil;
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
    NSLog(@"%@", NSStringFromCGRect(imgView.frame));
    BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                        bigRadius:imgView.frame.size.width * 0.48
                                         smallRadius:imgView.frame.size.width * 0.41
                                         targetPoint:point];
    
    if (pointInRound) {
        hitView = imgView;
    }
//    NSLog(@"%@", hitView);
    return hitView;
}

/**
 *  判断点触位置是否落在了颜色区域内
 */
- (BOOL)touchPointInsideCircle:(CGPoint)center bigRadius:(CGFloat)bigRadius smallRadius:(CGFloat)smallRadius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    if (dist >= bigRadius || dist <= smallRadius){
        return NO;
    }else{
        return YES;
    }
}

/**
 *  开始点击的方法
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"nihao");
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    //!!!:ATTENTION
//    CGPoint touchLocation = [touch locationInView:self.window];
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.41        //0.39
                         targetPoint:touchLocation]) {
//        NSLog(@"R = %d, G = %d, B = %d", (int)(components[0] * 255),
//              (int)(components[1] * 255),
//              (int)(components[2] * 255));
        self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
        self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
        self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
        self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        //!!!:ATTENTIOIN
//        viewColorPickerPositionIndicator.center = touchLocation;
        viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
//        viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:viewColorPickerPositionIndicator.center];
    viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
    }
}

/**
 *  手指在屏幕上移动的方法
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan:touches withEvent:event];
    
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *rValue1 = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];

  
  NSString *gVlaue1 = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue] ]];

  
  NSString *bValue1 = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue] ]];

  
  
    NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                     "<root>"
                     "<command_id></command_id>"
                     "<command_type>execute</command_type>"
                     "<id>%@</id>"
                     "<action>change_color</action>"
                     "<value>%@,%@,%@</value>"
                     "</root>",  self.logic_id,rValue1,gVlaue1,bValue1];
    
    NSDictionary *parameters = @{@"test" : str};
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    //内网
    NSLog(@"内网实际操作IP：%@",[[NSString alloc] initWithFormat:@"%@/phone/color_light.php",app.globalInternalIP]);
    
    [manager POST:[[NSString alloc] initWithFormat:@"http://%@/phone/color_light.php",app.globalInternalIP]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"成功: %@", string);
          }
          failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"失败: %@", error);
          }];
    
    
  }else{
  
    //外网
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/color_light.php"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"成功: %@", string);
          }
          failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"失败: %@", error);
          }];
  
  }
  
  
    
  
}


//*****************************获取屏幕点触位置的RGB值的方法************************************//
- (UIColor *) getPixelColorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    
    CGImageRef inImage = colorImageView.image.CGImage;
    
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil;
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(cgctx, rect, inImage);
    
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    CGContextRelease(cgctx);
    
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

//****************************************结束

@end

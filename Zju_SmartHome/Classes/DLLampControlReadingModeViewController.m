//
//  DLLampControlReadingModeViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/4.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControlReadingModeViewController.h"
#import "ZQSlider.h"
@interface DLLampControlReadingModeViewController ()
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UILabel *rValue;
@property (weak, nonatomic) IBOutlet UILabel *gValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;
@property (weak, nonatomic) IBOutlet UIView *colorPreview;
@end

@implementation DLLampControlReadingModeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    NSLog(@"00000 %@",self.logic_id);
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.tag = 10086;
    UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
    viewColorPickerPositionIndicator.tag = 10087;
    UIButton *btnPlay = [[UIButton alloc] init];
    
    ZQSlider *slider = [[ZQSlider alloc] init];
    slider.backgroundColor = [UIColor clearColor];
    
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.value = 30;
    
    [slider setMaximumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
    
    slider.continuous = YES;
    
    self.slider = slider;
    [slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    
    if (fabsf(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        imgView.image = [UIImage imageNamed:@"reading_5"];
        viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
        viewColorPickerPositionIndicator.layer.cornerRadius = 8;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(111, 111, 60, 60);
        slider.frame = CGRectMake(40, 260, 200, 10);
        
    }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        imgView.image = [UIImage imageNamed:@"reading_6"];
        viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
        viewColorPickerPositionIndicator.layer.cornerRadius = 10;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(135, 135, 60, 60);
        slider.frame = CGRectMake(50, 310, 225, 10);
        
    }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        imgView.image = [UIImage imageNamed:@"reading_6p"];
        viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
        viewColorPickerPositionIndicator.layer.cornerRadius = 12;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(150, 150, 60, 60);
        slider.frame = CGRectMake(85, 340, 200, 10);
        
    }
    
    imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
    
    
    imgView.userInteractionEnabled = YES;
    _imgView = imgView;
    
//    viewColorPickerPositionIndicator.backgroundColor = [UIColor colorWithRed:0.996 green:1.000 blue:0.678 alpha:1.000];
    viewColorPickerPositionIndicator.backgroundColor = [UIColor clearColor];
    
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"ct_icon_buttonbreak-off"] forState:UIControlStateNormal];
    
    [self.panelView addSubview:imgView];
    [self.panelView addSubview:viewColorPickerPositionIndicator];
    [self.panelView addSubview:btnPlay];
    [self.panelView addSubview:slider];
}

-(void)sliderValueChanged{
    //    NSLog(@"%d", self.slider.value);
    
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
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.41        //0.39
                         targetPoint:touchLocation]) {
        
        self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
        self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
        self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
        self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        //!!!:ATTENTIOIN
        //        viewColorPickerPositionIndicator.center = touchLocation;
        viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
        viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        
        ////在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
        
        //                //增加这几行代码
        //                AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        //                [securityPolicy setAllowInvalidCertificates:YES];
        //
        //                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //                [manager setSecurityPolicy:securityPolicy];
        //                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //
        //                NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        //                                 "<root>"
        //                                 "<command_id></command_id>"
        //                                 "<command_type>execute</command_type>"
        //                                 "<id>%@</id>"
        //                                 "<action>change_color</action>"
        //                                 "<value>%@,%@,%@</value>"
        //                                 "</root>",  self.logic_id,self.rValue.text,self.gValue.text,self.bValue.text];
        //
        //                NSDictionary *parameters = @{@"test" : str};
        //
        //                [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/color_light.php"
        //                   parameters:parameters
        //                      success:^(AFHTTPRequestOperation *operation,id responseObject){
        //                          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //                          NSLog(@"成功: %@", string);
        //                      }
        //                      failure:^(AFHTTPRequestOperation *operation,NSError *error){
        //                          NSLog(@"失败: %@", error);
        //                      }];
    }
}




/**
 *  手指在屏幕上移动的方法
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    //!!!:ATTENTION
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.41        //0.39
                         targetPoint:touchLocation]) {
        
        self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
        self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
        self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
        self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        //!!!:ATTENTIOIN
        //        viewColorPickerPositionIndicator.center = touchLocation;
        viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
        viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        
        
        int i, j, k;
        if ((i = arc4random() % 2)) {
            if ((j = arc4random() % 2)) {
                if ((k = arc4random() % 2)) {
                ////在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
                //                //增加这几行代码
                //                AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
                //                [securityPolicy setAllowInvalidCertificates:YES];
                //
                //                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                //                [manager setSecurityPolicy:securityPolicy];
                //                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                //
                //                NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                //                                 "<root>"
                //                                 "<command_id></command_id>"
                //                                 "<command_type>execute</command_type>"
                //                                 "<id>%@</id>"
                //                                 "<action>change_color</action>"
                //                                 "<value>%@,%@,%@</value>"
                //                                 "</root>",  self.logic_id,self.rValue.text,self.gValue.text,self.bValue.text];
                //
                //                NSDictionary *parameters = @{@"test" : str};
                //
                //                [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/color_light.php"
                //                   parameters:parameters
                //                      success:^(AFHTTPRequestOperation *operation,id responseObject){
                //                          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                //                          NSLog(@"成功: %@", string);
                //                      }
                //                      failure:^(AFHTTPRequestOperation *operation,NSError *error){
                //                          NSLog(@"失败: %@", error);
                //                      }];
                }
            }
        }
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
//
//  DLLampControlDinnerModeViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/11/28.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControlDinnerModeViewController.h"

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
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.tag = 10086;
    imgView.image = [UIImage imageNamed:@"circle"];
    imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
//    NSLog(@"image.size.width = %f, image.size.height = %f", imgView.image.size.width, imgView.image.size.height);
    imgView.userInteractionEnabled = YES;
    _imgView = imgView;
    [self.panelView addSubview:imgView];
    
    
    UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
    viewColorPickerPositionIndicator.tag = 10087;
    viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
//    viewColorPickerPositionIndicator.backgroundColor =
//    [self getPixelColorAtLocation:viewColorPickerPositionIndicator.center];
    viewColorPickerPositionIndicator.backgroundColor = [UIColor colorWithRed:0.678 green:0.169 blue:0.710 alpha:1.000];
    viewColorPickerPositionIndicator.layer.cornerRadius = 10;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    
    [self.panelView addSubview:viewColorPickerPositionIndicator];
    
    UIButton *btnPlay = [[UIButton alloc] init];
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"ct_icon_buttonbreak-off"] forState:UIControlStateNormal];
    btnPlay.frame = CGRectMake(135, 135, 60, 60);
    [self.panelView addSubview:btnPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





//****************************************开始
/**
 *  初始化MyscrollView里面的一些子控件
 *  包括一个UIImageView（里面放待取颜色的图片一张）   注意:UIImageView的大小只能跟图片一样大.要不然取色不对
 *  还有一个取色位置的指示器UIView *viewColorPickerPositionIndicator
 */
//- (void)initSubviews{
//    
//    UIImageView *imgView = [[UIImageView alloc]init];
//    imgView.tag = 10086;
//    imgView.image = [UIImage imageNamed:@"circle"];
//    
//    imgView.frame = CGRectMake(0.0f, 0.0f, imgView.image.size.width, imgView.image.size.height);
//    [self addSubview:imgView];
//    
//    
//    UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
//    viewColorPickerPositionIndicator.tag = 10087;
//    viewColorPickerPositionIndicator.frame = CGRectMake(33, 33, 20, 20);
//    viewColorPickerPositionIndicator.backgroundColor =
//    [self getPixelColorAtLocation:viewColorPickerPositionIndicator.center];
//    viewColorPickerPositionIndicator.layer.cornerRadius = 10;
//    viewColorPickerPositionIndicator.layer.borderWidth = 2;
//    
//    [self addSubview:viewColorPickerPositionIndicator];
//}


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
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBegan:touches withEvent:event];
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

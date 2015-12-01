//
//  CYFFurnitureViewController.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFFurnitureViewController : UIViewController

//从二维码扫描界面传过来的Mac值；
@property(nonatomic,copy) NSString *macFromQRCatcher;


@property(nonatomic,copy)NSString *area;

@end

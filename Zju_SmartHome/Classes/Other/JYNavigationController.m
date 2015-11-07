//
//  JYNavigationController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/4.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYNavigationController.h"

@interface JYNavigationController ()

@end

@implementation JYNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}
//一个类只会调用一次
+(void)initialize
{
    //1.设置导航栏的主题
    [self setupNavBarTheme];
    
    //2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
    
}

//设置导航栏的主题
+(void)setupNavBarTheme
{
    //1.去除apperance对象
    UINavigationBar *navBar=[UINavigationBar appearance];
    
    //设置背景
    //[navBar setBackgroundImage:[UIImage imageNamed:@"btn_login_for6"] forBarMetrics:UIBarMetricsDefault];
    //[navBar setBackgroundColor:[UIColor blackColor]];
    
    //2.设置标题属性
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor]=[UIColor whiteColor];
    textAttrs[UITextAttributeTextShadowOffset]=[NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont]=[UIFont boldSystemFontOfSize:18];
    
    [navBar setTitleTextAttributes:textAttrs];
}

//设置导航栏按钮主题
+(void)setupBarButtonItemTheme
{
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    
    //设置文字属性
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor]=[UIColor whiteColor];
    textAttrs[UITextAttributeTextShadowOffset]=[NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont]=[UIFont systemFontOfSize:18];
    
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];

}
@end

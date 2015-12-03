//
//  JYChangePwdViewController.m
//  Zju_SmartHome
//
//  Created by 顾金跃 on 15/12/3.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYChangePwdViewController.h"
#import "RESideMenu.h"

@interface JYChangePwdViewController ()

@end

@implementation JYChangePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBar];
    
}

-(void)setNavigationBar
{
    self.navigationController.navigationBar.hidden=NO;
    
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"修改密码"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;

}

- (void)leftBtnClicked{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[RESideMenu class]]) {
            controller.navigationController.navigationBar.hidden=YES;
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
}
@end

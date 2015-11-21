//
//  CYFCollectionViewCell.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFCollectionViewCell.h"
#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@implementation CYFCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        //这里需要初始化imageView
        self.imageBtn=[[UIButton alloc]init];
        self.descLabel=[[UILabel alloc]init];
        self.descLabel.font=[UIFont systemFontOfSize:10];
        
        UIView *view=[[UIView alloc]init];
        //view.backgroundColor=[UIColor grayColor];
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.layer.borderWidth = 0.5;
        self.view=view;
        
        [view addSubview:self.imageBtn];
        [view addSubview:self.descLabel];
        [self addSubview:self.view];
        
    }
    return self;
}

//这个方法里调整控件frame是最准确的
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.view.frame=CGRectMake(0, 0, UISCREEN_WIDTH/ 3+0.5, UISCREEN_WIDTH/ 3+0.5);
    self.imageBtn.frame=CGRectMake((self.view.frame.size.width-32)/2, self.view.frame.size.height-82, 32, 32);
    self.descLabel.frame=CGRectMake((UISCREEN_WIDTH/ 3-40)/2+5, (UISCREEN_WIDTH/ 3-40)/2+32, 32, 10);
}

@end

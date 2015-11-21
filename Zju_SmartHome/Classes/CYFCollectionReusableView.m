//
//  CYFCollectionReusableView.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFCollectionReusableView.h"

@implementation CYFCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.title=[[UILabel alloc]init];
        self.title.textColor=[UIColor blackColor];
        self.title.textAlignment=NSTextAlignmentCenter;
        self.title.backgroundColor=[UIColor grayColor];
        
        UIView *view=[[UIView alloc]init];
        self.view=view;
        self.view.backgroundColor=[UIColor greenColor];
        [self.view addSubview:self.title];
        
        [self addSubview:self.view];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.title.frame=CGRectMake(0, 5, self.window.frame.size.width, 20);
    self.view.frame=CGRectMake(0, 5, self.window.frame.size.width, 30);
}

@end

//
//  CYFCollectionReusableView.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFCollectionReusableView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation CYFCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 20, SCREEN_WIDTH, SCREEN_HEIGHT / 20)];
    self.title.textColor = [UIColor blackColor];
    self.title.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.title];
    
    
  }
  return self;
}

@end

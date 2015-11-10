//
//  CYFCollectionViewCell.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/10.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFCollectionViewCell.h"
#import "AppDelegate.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (DeviceWidth-80)/2, (DeviceWidth-80)/2)];
        [self.imageView setUserInteractionEnabled:true];
        
        [self addSubview:self.imageView];
        
    }
    return self;
}

@end

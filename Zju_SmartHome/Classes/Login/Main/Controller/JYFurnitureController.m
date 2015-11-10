//
//  JYFurnitureController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/9.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYFurnitureController.h"

@interface JYFurnitureController ()<NSURLConnectionDataDelegate>
@property(nonatomic,strong)NSMutableData *receiveData;
@property(nonatomic,strong)NSConnection *connection;
@end

@implementation JYFurnitureController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
}

@end

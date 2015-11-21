//
//  JYMainVIew.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYMainViewDelegate <NSObject>
@optional
-(void)furnitureClick;
@end

@interface JYMainView : UIView
+(instancetype)mainViewXib;
@property(nonatomic,weak)id<JYMainViewDelegate>delegate;
@end

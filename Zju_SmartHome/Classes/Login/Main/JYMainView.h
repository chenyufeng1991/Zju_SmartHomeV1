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
-(void)officeClick;
-(void)furnitureClick;
-(void)productClick;
-(void)customClick;
@end

@interface JYMainView : UIView
+(instancetype)mainViewXib;
@property(nonatomic,weak)id<JYMainViewDelegate>delegate;

//定位

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end

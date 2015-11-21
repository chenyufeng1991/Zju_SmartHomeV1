//
//  CYFCollectionViewCell.h
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFCollectionViewCell : UICollectionViewCell
//cell具体显示的view
@property(nonatomic,strong)UIView *view;
//电器图片
@property(nonatomic,strong)UIButton *imageBtn;
//电器描述文字
@property(nonatomic,strong)UILabel *descLabel;
@end

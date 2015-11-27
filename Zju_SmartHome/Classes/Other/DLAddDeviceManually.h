//
//  DLAddDeviceManually.h
//  Zju_SmartHome
//
//  Created by TooWalker on 15/11/27.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLAddDeviceManuallyDelegate <NSObject>
@optional
/**
 *  点击“下一步”按钮的代理
 */
-(void)nextStepGo;

@end

@interface DLAddDeviceManually : UIView

@property (weak, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet UITextField *deviceID;

@property (nonatomic, weak) id<DLAddDeviceManuallyDelegate> delegate;

@end

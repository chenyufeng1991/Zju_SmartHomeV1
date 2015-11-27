//
//  DLAddDeviceManually.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/11/27.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLAddDeviceManually.h"

@interface DLAddDeviceManually()
- (IBAction)nextStep:(id)sender;

@end

@implementation DLAddDeviceManually

- (IBAction)nextStep:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nextStepGo)]) {
        [self.delegate nextStepGo];
    }
}
@end

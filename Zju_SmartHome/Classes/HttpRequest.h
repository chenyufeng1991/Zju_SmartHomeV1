//
//  HttpRequest.h
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/29.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject


//使用mac值获取logic值；
+ (void)getLogicIdfromMac:(NSString*)macValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;


//把logicId发送到服务器；
+ (void)registerDeviceToServer:(NSString*)logicId deviceName:(NSString*)deviceName sectionName:(NSString*)sectionName type:(NSString *)type success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//从服务器获得所有的注册设备；
+ (void)findAllDeviceFromServer :(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

+ (void)getInternalNetworkGateIP:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;

//删除设备
+ (void)deleteDeviceFromServer:(NSString*)logicId success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure;
@end

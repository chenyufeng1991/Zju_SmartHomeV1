//
//  HttpRequest.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/29.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"


@implementation HttpRequest

+ (void)getLogicIdfromMac:(NSString*)macValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  //    NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
  //    "<root>"
  //    "<command_id>10001</command_id>"
  //    "<command_type>execute</command_type>"
  //    "<id>123</id>"
  //    "<action>warmcold</action>"
  //    "<value>80</value>"
  //    "</root>";
  
  
  NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id></command_id>"
                   "<command_type>execute</command_type>"
                   "<id>145</id>"
                   "<action>open</action>"
                   "<value>%@</value>"
                   "</root>",macValue];
  
  NSDictionary *parameters = @{@"test" : str};
  
  [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/getLogicIdfromMac.php"
     parameters:parameters
        success:success
        failure:failure];
}


+ (void)registerDeviceToServer:(NSString*)logicId deviceName:(NSString*)deviceName sectionName:(NSString*)sectionName success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //1.创建请求管理对象
  AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
  //2.说明服务器返回的是json参数
  manager.responseSerializer=[AFHTTPResponseSerializer serializer];
  
  //3.封装请求参数
  //  NSMutableDictionary *params=[NSMutableDictionary dictionary];
  //  params[@"is_app"] = @"1";
  //  params[@"equipment.name"] = deviceName;
  //  params[@"equipment.logic_id"] = logicId;
  //  params[@"equipment.scene_name"] = sectionName;
  
  NSDictionary *params = @{@"is_app":@"1",
                           @"equipment.name":deviceName,
                           @"equipment.logic_id":logicId,
                           @"equipment.scene_name" :sectionName};
  
  //4.发送请求
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/create"
     parameters:params
        success:success
        failure:failure];
}


+ (void)findAllDeviceFromServer :(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //1.创建请求管理对象
  AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
  
  //2.说明服务器返回的是json参数
  manager.responseSerializer=[AFJSONResponseSerializer serializer];
  
  //3.封装请求参数
  NSMutableDictionary *params=[NSMutableDictionary dictionary];
  params[@"is_app"]=@"1";
  
  //4.发送请求
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/find"
 parameters:params
    success:success
    failure:failure];
  
}

@end

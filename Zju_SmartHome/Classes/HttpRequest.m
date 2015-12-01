//
//  HttpRequest.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/11/29.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

#import "AppDelegate.h"

@implementation HttpRequest

+ (void)getLogicIdfromMac:(NSString*)macValue success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  
  NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id></command_id>"
                   "<command_type>execute</command_type>"
                   "<id>145</id>"
                   "<action>open</action>"
                   "<value>%@</value>"
                   "</root>",macValue];
  
  NSDictionary *parameters = @{@"test" : str};
  
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    //内网；
    NSString *url  = [[NSString alloc] initWithFormat:@"http://%@:8000/phone/getLogicIdfromMac.php",app.globalInternalIP];
    
    [manager POST:url
       parameters:parameters
          success:success
          failure:failure];
    NSLog(@"使用内网 向网关发送Mac值");
  }else{
    //外网；
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/getLogicIdfromMac.php"
       parameters:parameters
          success:success
          failure:failure];
    
    NSLog(@"使用外网 向网关发送Mac值");
    
  }
  
}


+ (void)registerDeviceToServer:(NSString*)logicId deviceName:(NSString*)deviceName sectionName:(NSString*)sectionName type:(NSString*)type success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
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
  
  NSLog(@"66666666 %@ %@ %@ %@",deviceName,logicId,sectionName,type);
  
  NSDictionary *params = @{@"is_app":@"1",
                           @"equipment.name":deviceName,
                           @"equipment.logic_id":logicId,
                           @"equipment.scene_name" :sectionName,
                           @"equipment.type":type
                           };
  
  NSLog(@"我看看这个type有没有被注册呢%@",type);
  
   AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8888/paladin/Equipment/create",app.globalInternalIP];
    
    //内网发送请求
    [manager POST:url
       parameters:params
          success:success
          failure:failure];
    NSLog(@"使用内网 向服务器注册设备");
  }else{
  
    //外网发送请求
  [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/create"
     parameters:params
        success:success
        failure:failure];
    
    NSLog(@"使用外网 向服务器注册设备");
  }
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
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if (app.isInternalNetworkGate) {
    //内网；
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@:8888/paladin/Equipment/find",app.globalInternalIP];
    
    [manager POST:url
       parameters:params
          success:success
          failure:failure];
    NSLog(@"使用内网从服务器获取所有注册设备");
  }else{
    //外网；
    [manager POST:@"http://60.12.220.16:8888/paladin/Equipment/find"
       parameters:params
          success:success
          failure:failure];
  
    NSLog(@"使用外网从服务器获取所有注册设备");
  }
  
}


+ (void)getInternalNetworkGateIP:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error))failure{
  
  //增加这几行代码；
  AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
  [securityPolicy setAllowInvalidCertificates:YES];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager setSecurityPolicy:securityPolicy];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSString *str = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<root>"
                   "<command_id>10001</command_id>"
                   "<command_type>get</command_type>"
                   "<id>123</id>"
                   "<action>get_gateway_ip</action>"
                   "<value>100</value>"
                   "</root>"];
  
  NSDictionary *params = @{@"test" : str};
  
  //通过外网来获取内网的IP地址；
  [manager POST:@"http://test.ngrok.joyingtec.com:8000/ip.php"
     parameters:params
        success:success
        failure:failure];
  NSLog(@"获取内网IP地址。。。");
  
}

@end

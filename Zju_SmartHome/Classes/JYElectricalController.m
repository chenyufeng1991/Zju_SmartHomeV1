//
//  JYElectricalController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/21.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "JYElectricalController.h"
#import "AFNetworking.h"

@interface JYElectricalController ()<NSURLConnectionDataDelegate>
@property(nonatomic,strong)NSURLConnection *connection;
@property(nonatomic,strong)NSMutableData *receiveData;
@end

@implementation JYElectricalController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self test];
}

-(void)test
{
    NSURL *url=[NSURL URLWithString:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"];
    
    //创建请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<root>"
    "<command_id>10001</command_id>"
    "<command_type>execute</command_type>"
    "<id>123</id>"
    "<action>brightness</action>"
    "<value>80</value>"
    "</root>";
    
    
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //连接服务器
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
     {
         //data就是从网络返回的数据
         //对data处理
         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"====%@",string);
         
         //重新回到主线程
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            //更新UI
                            NSLog(@"回来主线程更新UI");
                            
                        });
     }];

}

-(void)test2
{
    NSURL *url=[NSURL URLWithString:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"];
    
    //创建请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<root>"
    "<command_id>10001</command_id>"
    "<command_type>execute</command_type>"
    "<id>123</id>"
    "<action>brightness</action>"
    "<value>80</value>"
    "</root>";
    
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    self.connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(self.connection)
    {
        self.receiveData=[NSMutableData data];
    }
}
//接受到服务器回应的时候调用次方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"开始接受");
    [self.receiveData setLength:0];
}

//接受到服务器传输数据的时候调用,此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr=[[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"＝＝＝＝%@",receiveStr);
    NSLog(@"接受完成了哦");
}

//网络请求中出现错误(断网,连接超时等)
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


-(void)test3
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<root>"
    "<command_id>10001</command_id>"
    "<command_type>execute</command_type>"
    "<id>123</id>"
    "<action>brightness</action>"
    "<value>80</value>"
    "</root>";
    
    NSDictionary *parameters = @{@"test":str};
    
    [manager POST:@"http://test.ngrok.joyingtec.com:8000/phone/yw_light.php"parameters:parameters
     
         success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
             
             NSLog(@"Success: %@", responseObject);
             
         }failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
             
             NSLog(@"Error: %@", error);
             
         }];
}
@end

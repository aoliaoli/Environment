//
//  NetWorkRequestManager.m
//  Check
//
//  Created by 奥莉 on 16/7/12.
//  Copyright © 2016年 奥莉. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager

//将字典转化为NSData
- (NSData *)DataFromDic:(NSDictionary *)dic{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [array addObject:str];
    }
    NSString *string = [array componentsJoinedByString:@"&"];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)requestWithType:(RequestType)requestType urlString:(NSString *)urlString dic:(NSDictionary *)dic str:(NSString *)str successful:(Successful)successful errorMessage:(Error)errorMessage{
    self.successful = successful;
    self.errorMessage = errorMessage;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    if (requestType == POST) {
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        if (dic.count>0) {
            [request setHTTPBody:[self DataFromDic:dic]];
        }
        if (str.length!=0) {
//            [request setValue:@"text/plain;chatset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            self.successful(data);
        }else{
            self.errorMessage(error);
        }
    }];
    [task resume];
    
    
}

+ (void)requestWithType:(RequestType)requestType urlString:(NSString *)urlString dic:(NSDictionary *)dic str:(NSString *)str successful:(Successful)successful errorMessage:(Error)errorMessage{
    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc] init];
    [manager requestWithType:requestType urlString:urlString dic:dic str:str successful:successful errorMessage:errorMessage];
}

@end

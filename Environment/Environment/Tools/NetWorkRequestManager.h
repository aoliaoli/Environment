//
//  NetWorkRequestManager.h
//  Check
//
//  Created by 奥莉 on 16/7/12.
//  Copyright © 2016年 奥莉. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RequestType){
    GET,
    POST
};

typedef void(^Successful)(NSData *data);
typedef void(^Error)(NSError *error);


@interface NetWorkRequestManager : NSObject


@property (nonatomic, copy)Successful successful;
@property (nonatomic, copy)Error errorMessage;

+ (void)requestWithType:(RequestType)requestType urlString:(NSString *)urlString dic:(NSDictionary *)dic str:(NSString *)str successful:(Successful)successful errorMessage:(Error)errorMessage;


@end

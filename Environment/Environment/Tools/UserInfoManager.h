//
//  UserInfoManager.h
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject


// 保存用户的id
+ (void)conserveUserID:(NSString *)userID;
// 获取用户ID
+ (NSString *)getUserID;
// 取消用户的ID
+ (void)cancelUserID;

// 保存用户的name
+ (void)conserveUserName:(NSString *)userName;
// 获取用户name
+ (NSString *)getUserName;

//保存用户密码
+ (void)conserveUserPwd:(NSString *)userpwd;
// 获取用户密码
+ (NSString *)getUserPwd;

// 保存用户的id
+ (void)conserveEID:(NSInteger)EID;
// 获取用户ID
+ (NSInteger)getEID;
// 取消用户的ID
+ (void)cancelEID;


@end

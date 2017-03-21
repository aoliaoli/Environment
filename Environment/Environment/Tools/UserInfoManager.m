//
//  UserInfoManager.m
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager


// 保存用户的id
+ (void)conserveUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"Sid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取用户ID
+ (NSString *)getUserID {
    NSString *ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"Sid"];
    if (ID == nil) {
        return @" ";
    }
    return ID;
}
// 取消用户的ID
+ (void)cancelUserID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Sid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// 保存用户的name
+ (void)conserveUserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取用户name
+ (NSString *)getUserName{
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    if (name == nil) {
        return  @" ";
    }
    return name;
}

//保存用户密码
+ (void)conserveUserPwd:(NSString *)userpwd{
    [[NSUserDefaults standardUserDefaults] setObject:userpwd forKey:@"UserPwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取用户密码
+ (NSString *)getUserPwd{
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPwd"];
    if (pwd == nil) {
        return @" ";
    }
    return pwd;
}

// 保存用户的id
+ (void)conserveEID:(NSInteger)EID{
    [[NSUserDefaults standardUserDefaults] setInteger:EID forKey:@"eid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 获取用户ID
+ (NSInteger)getEID{
    NSInteger eid = [[NSUserDefaults standardUserDefaults] integerForKey:@"eid"];
    if (eid == 0) {
        return 0;
    }
    return eid;
}
// 取消用户的ID
+ (void)cancelEID{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eid"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


@end

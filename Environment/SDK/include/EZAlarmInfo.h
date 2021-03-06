//
//  EZAlarmInfo.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 15/9/16.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 此类为报警信息对象
@interface EZAlarmInfo : NSObject

/// 报警ID
@property (nonatomic, copy) NSString *alarmId;
/// 设备序列号
@property (nonatomic, copy) NSString *deviceSerial;
/// 通道号
@property (nonatomic) NSInteger cameraNo;
/// 报警名称
@property (nonatomic, copy) NSString *alarmName;
/// 报警图片
@property (nonatomic, copy) NSString *alarmPicUrl;
/// 报警开始时间
@property (nonatomic, strong) NSDate *alarmStartTime;
/// 报警类型
@property (nonatomic) NSInteger alarmType;
/// 是否已读
@property (nonatomic) BOOL isRead;
/// 报警录像结束时间时间延后偏移量，通过alarmStartTime加上延后偏移量获得报警录像的具体结束时间
@property (nonatomic) NSInteger delayTime;
/// 报警录像开始时间提前偏移量，通过alarmStartTime减去提前偏移量获得报警录像的具体开始时间
@property (nonatomic) NSInteger preTime;

/// 4530 扩展字段
@property (nonatomic, copy) NSString *customerType;
/// 4530 扩展字段
@property (nonatomic, copy) NSString *customerInfo;

@end

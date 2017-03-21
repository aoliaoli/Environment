//
//  QueryManager.h
//  Environment
//
//  Created by 奥莉 on 2017/3/21.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "EnvironmentModel.h"

@interface QueryManager : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;// 数据

@property (nonatomic, strong) FMDatabase *db;// check数据库


+(QueryManager *)shareInstance;

//获取所有数据
-(void)getAllValues;

//添加数据
-(void)insertModel:(EnvironmentModel *)model;

// 删除所有数据
-(void)deleteAllData;

@end

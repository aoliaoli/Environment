//
//  QueryManager.m
//  Environment
//
//  Created by 奥莉 on 2017/3/21.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "QueryManager.h"

static QueryManager *manager = nil;

@implementation QueryManager



+(QueryManager *)shareInstance{
    @synchronized (self) {
        if (manager == nil) {
            manager = [[QueryManager alloc] init];
        }
    }
    return manager;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        //初始化数据数组
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        //获取数据库路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"environment.sqlite"];
        NSLog(@"%@",dbPath);
        
        //创建FMDB数据库的方法
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        self.db = db;
        if ([self.db open]) {
            //创建表，存储联系人信息
            [self createTable];
        }
        
    }
    return self;}



//创建数据表
-(void)createTable{
    //声明创建表格的sql语句
    NSArray *array = [NSArray arrayWithObjects:@"create table IF NOT EXISTS hdata(eid text null,edate text null,etime text null,numb1o2 text null,numb2o2 text null,temperature text null,humidity text null,lever text null)",nil];
    for (NSString *str in array) {
        if ([self.db executeUpdate:str]) {
            NSLog(@"数据表创建成功");
        }else{
            NSLog(@"数据表创建失败");
        }
    }
    
}

//获取所有数据
-(void)getAllValues{
    if (self.dataArray.count != 0) {
        [self.dataArray removeAllObjects];
    }
    
    NSString *selectSql = @"select * from hdata";
    FMResultSet *result = [self.db executeQuery:selectSql];
    while ([result next]) {
        NSString *eid = [result stringForColumn:@"eid"];
        NSString *edate = [result stringForColumn:@"edate"];
        NSString *etime = [result stringForColumn:@"etime"];
        NSString *numb1o2 = [result stringForColumn:@"numb1o2"];
        NSString *numb2o2 = [result stringForColumn:@"numb2o2"];
        NSString *temperature = [result stringForColumn:@"temperature"];
        NSString *humidity = [result stringForColumn:@"humidity"];
        NSString *lever = [result stringForColumn:@"lever"];
        EnvironmentModel *model = [[EnvironmentModel alloc] initWitheid:eid edate:edate etime:etime numb1o2:numb1o2 numb2o2:numb2o2 temperature:temperature humidity:humidity lever:lever];
        [self.dataArray addObject:model];
        
    }

}

//添加数据
-(void)insertModel:(EnvironmentModel *)model{
    NSString *insertSql = @"insert into hdata values(?,?,?,?,?,?,?,?)";
    [self.db executeUpdate:insertSql,model.eid,model.edate,model.etime,model.numb1o2,model.numb2o2,model.temperature,model.humidity,model.lever];
    //添加联系人，保存到数据数组中
    [self.dataArray addObject:model];
}

// 删除所有数据
-(void)deleteAllData{
    NSString *deleteSql = @"delete from hdata";
    [self.db executeUpdate:deleteSql];
    [self.dataArray removeAllObjects];
}

@end

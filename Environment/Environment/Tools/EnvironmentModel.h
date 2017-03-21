//
//  EnvironmentModel.h
//  Environment
//
//  Created by 奥莉 on 2017/3/21.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvironmentModel : NSObject
//eid text null,edate text null,etime text null,numb1o2 text null,numb2o2 text null,temperature text null,humidity text null,lever text null

@property (nonatomic, copy) NSString *eid;
@property (nonatomic, copy) NSString *edate;
@property (nonatomic, copy) NSString *etime;
@property (nonatomic, copy) NSString *numb1o2;
@property (nonatomic, copy) NSString *numb2o2;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *humidity;
@property (nonatomic, copy) NSString *lever;

-(instancetype)initWitheid:(NSString *)eid edate:(NSString *)edate etime:(NSString *)etime numb1o2:(NSString *)numb1o2 numb2o2:(NSString *)numb2o2 temperature:(NSString *)temperature humidity:(NSString *)humidity lever:(NSString *)lever;

@end

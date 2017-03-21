//
//  EnvironmentModel.m
//  Environment
//
//  Created by 奥莉 on 2017/3/21.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "EnvironmentModel.h"

@implementation EnvironmentModel


-(instancetype)initWitheid:(NSString *)eid edate:(NSString *)edate etime:(NSString *)etime numb1o2:(NSString *)numb1o2 numb2o2:(NSString *)numb2o2 temperature:(NSString *)temperature humidity:(NSString *)humidity lever:(NSString *)lever{
    self = [super init];
    if (self) {
        self.eid = eid;
        self.edate = edate;
        self.etime = etime;
        self.numb1o2 = numb1o2;
        self.numb2o2 = numb2o2;
        self.temperature = temperature;
        self.humidity = humidity;
        self.lever = lever;
    }
    return self;
}


@end

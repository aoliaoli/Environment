//
//  homeModel.m
//  Environment
//
//  Created by 奥莉 on 2017/3/17.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "homeModel.h"

@implementation homeModel

-(instancetype)initWithName:(NSString *)name istrue:(BOOL)istrue{
    self = [super init];
    if (self) {
        self.name = name;
        self.istrue = istrue;
    }
    return self;
}

@end

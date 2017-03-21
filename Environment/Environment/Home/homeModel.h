//
//  homeModel.h
//  Environment
//
//  Created by 奥莉 on 2017/3/17.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeModel : NSObject


@property (nonatomic,strong)NSString *name;//状态名字
@property (nonatomic)BOOL istrue;//是否警报


-(instancetype)initWithName:(NSString *)name istrue:(BOOL)istrue;

@end

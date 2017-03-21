//
//  EnvironmentModelCell.h
//  Environment
//
//  Created by 奥莉 on 2017/3/21.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvironmentModel.h"

@interface EnvironmentModelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eidLabel;
@property (weak, nonatomic) IBOutlet UILabel *edateLabel;
@property (weak, nonatomic) IBOutlet UILabel *etimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numb1o2Label;
@property (weak, nonatomic) IBOutlet UILabel *numb2o2Label;
@property (weak, nonatomic) IBOutlet UILabel *tempertureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lerverLabel;

-(void)setDataWithModel:(EnvironmentModel *)model;

@end

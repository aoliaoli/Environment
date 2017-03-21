//
//  EnvironmentModelCell.m
//  Environment
//
//  Created by 奥莉 on 2017/3/21.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "EnvironmentModelCell.h"


@implementation EnvironmentModelCell



-(void)setDataWithModel:(EnvironmentModel *)model{
    //设置边框
    self.eidLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.edateLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.etimeLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.numb1o2Label.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.numb2o2Label.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.humidityLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.lerverLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.tempertureLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    
    self.eidLabel.layer.borderWidth = 1;
    self.edateLabel.layer.borderWidth = 1;
    self.etimeLabel.layer.borderWidth = 1;
    self.numb1o2Label.layer.borderWidth = 1;
    self.numb2o2Label.layer.borderWidth = 1;
    self.humidityLabel.layer.borderWidth = 1;
    self.lerverLabel.layer.borderWidth = 1;
    self.tempertureLabel.layer.borderWidth = 1;
    
    self.eidLabel.text = model.eid;
    self.edateLabel.text = model.edate;
    self.etimeLabel.text = model.etime;
    self.numb1o2Label.text = model.numb1o2;
    self.numb2o2Label.text = model.numb2o2;
    self.tempertureLabel.text = model.temperature;
    self.humidityLabel.text= model.humidity;
    self.lerverLabel.text = model.lever;
    
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

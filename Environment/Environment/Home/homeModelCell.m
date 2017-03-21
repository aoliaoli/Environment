//
//  HomeCell.m
//  Environment
//
//  Created by 奥莉 on 2017/3/17.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "homeModelCell.h"

@implementation homeModelCell
- (void)setDataWithModel:(homeModel *)model{
    self.nameLabel.text = model.name;
    if ([model.name isEqual:@"门禁1号"] || [model.name isEqual:@"门禁2号"]) {
        if (model.istrue) {
            self.imageView.image = [UIImage imageNamed:@"红圈"];
        }else{
            self.imageView.image = [UIImage imageNamed:@"绿圈"];
        }
    }else{
        if (model.istrue) {
            self.imageView.image = [UIImage imageNamed:@"绿圈"];
        }else{
            self.imageView.image = [UIImage imageNamed:@"红圈"];
        }
    }
    
}
@end

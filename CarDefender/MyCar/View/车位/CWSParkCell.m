//
//  CWSParkCell.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSParkCell.h"

@implementation CWSParkCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)distanceBtn:(UIButton *)sender {
    
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"parkGoNav" object:@{@"lat":self.lat,@"lon":self.lon}];
            MyLog(@"到这去%@-%@",self.lat,self.lon);
        }
            break;
            
        default:
            break;
    }
}
@end

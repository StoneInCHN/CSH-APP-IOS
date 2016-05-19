//
//  CarWashMarkView.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarWashMarkView.h"

@implementation CarWashMarkView
- (id)initWithFrame:(CGRect)frame Park:(Park*)park
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"CarWashMarkView" owner:self options:nil][0];
        self.frame = frame;
        _park = park;
        [self reloadCell:park];
    }
    return self;
}
-(void)reloadCell:(Park*)park{
    _park = park;
    self.titleLabel.text = park.name;
    //    self.distaceLabel.text = [NSString stringWithFormat:@"%@米",park.distance];
//    int distance = [park.distance intValue];
//    if (distance >= 1000) {
//        self.distaceLabel.text = [NSString stringWithFormat:@"%.1f千米",(float)distance/1000];
//    }else{
//        self.distaceLabel.text = [NSString stringWithFormat:@"%i米",distance];
//    }
    self.timeLabel.text = [NSString stringWithFormat:@"营业时间: %@",park.date];
    self.addressLabel.text = park.addr;
}
- (IBAction)btnClick:(UIButton *)sender {
    //    MyLog(@"%@",_park.name);
    if (sender.tag == 1) {
        [self.delegate parkCellClick:_park];
    }else{
        [self.delegate parkCellNavClick:_park];
    }
}


@end

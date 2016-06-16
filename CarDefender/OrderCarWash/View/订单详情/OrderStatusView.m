//
//  OrderStatusView.m
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "OrderStatusView.h"
#import "UIImageView+WebCache.h"

@interface OrderStatusView()
{
    NSDictionary *dataDic;
}
@end

@implementation OrderStatusView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OrderStatusView" owner:self options:nil] lastObject];
        self.frame = frame;
        self.statusImageView = (UIImageView *)[self viewWithTag:1];
        self.statusLabel = (UILabel *)[self viewWithTag:2];
        dataDic = [NSDictionary dictionaryWithDictionary:dic];
        [self showUI];
    }
    return self;
    
    
}


- (void)showUI

{
    NSString *str = [NSString stringWithFormat:@"%@",dataDic[@"chargeStatus"]];
    if ([str isEqualToString:@"RESERVATION"]) {
        self.statusLabel.text = @"预约中，等待商家接单...";
        self.statusImage.image = [UIImage imageNamed:@"yuyuezhong"];
    }else if ([str isEqualToString:@"RESERVATION_SUCCESS"]){
        self.statusLabel.text = @"预约成功，商家已经接单";
        self.statusImage.image = [UIImage imageNamed:@"dingdan_yiyong"];
    }else if ([str isEqualToString:@"RESERVATION_FAIL"]){
        self.statusLabel.text = @"预约失败，返回重新预约";
    }else if ([str isEqualToString:@"UNPAID"]){
        self.statusLabel.text = @"未支付，订单超过规定时间自动关闭";
        self.statusImage.image = [UIImage imageNamed:@"dingdan_guoqi"];
    }else if ([str isEqualToString:@"PAID"]){
        self.statusLabel.text = @"订单已支付";
        self.statusImage.image = [UIImage imageNamed:@"dingdan_yiyong"];
    }else if ([str isEqualToString:@"FINISH"]){
        self.statusLabel.text = @"订单完成";
        self.statusImage.image = [UIImage imageNamed:@"dingdan_yiyong"];
    }else if ([str isEqualToString:@"OVERDUE"]){
        self.statusLabel.text = @"订单过期";
        self.statusImage.image = [UIImage imageNamed:@"dingdan_guoqi"];
    }
}

@end

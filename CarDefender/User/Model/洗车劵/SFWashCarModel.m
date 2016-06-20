//
//  SFWashCarModel.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/19.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFWashCarModel.h"

@implementation SFWashCarModel

- (instancetype)initWithData:(NSDictionary *)dict {
    if (self = [super init]) {
        NSDictionary *carWashingCoupon = dict[@"carWashingCoupon"];
        self.tenantName = carWashingCoupon[@"tenantName"];
        self.remark = carWashingCoupon[@"remark"];
        self.couponName = carWashingCoupon[@"couponName"];
        self.remainNum = [NSString stringWithFormat:@"%@",dict[@"remainNum"]];
        self.identify = [NSString stringWithFormat:@"%@",dict[@"id"]];
    }
    return self;
}
@end

//
//  CarWash.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarWash.h"

@implementation CarWash
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super initWithDic:lDic]) {
        self.parkID = [NSString stringWithFormat:@"%@",lDic[@"id"]];
        self.priceDesc = [NSString stringWithFormat:@"%@",lDic[@"des"]];
        self.longitude = [NSString stringWithFormat:@"%@",lDic[@"lon"]];
        self.addr = [NSString stringWithFormat:@"%@",lDic[@"address"]];
        self.tel = [NSString stringWithFormat:@"%@",lDic[@"tel"]];
        self.distance = [NSString stringWithFormat:@"%@",lDic[@"mile"]];
        self.picUrl = [NSString stringWithFormat:@"%@",lDic[@"pic"]];
        self.latitude = [NSString stringWithFormat:@"%@",lDic[@"lat"]];
    }
    return self;
}
@end

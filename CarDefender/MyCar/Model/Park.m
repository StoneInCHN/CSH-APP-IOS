//
//  Park.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Park.h"

@implementation Park
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.parkID = [NSString stringWithFormat:@"%@",lDic[@"parkID"]];
        self.name = [NSString stringWithFormat:@"%@",lDic[@"name"]];
        self.cityName = [NSString stringWithFormat:@"%@",lDic[@"cityName"]];
        self.areaName = [NSString stringWithFormat:@"%@",lDic[@"areaName"]];
        self.addr = [NSString stringWithFormat:@"%@",lDic[@"addr"]];
        self.leftNum = [NSString stringWithFormat:@"%@",lDic[@"leftNum"]];
        self.total = [NSString stringWithFormat:@"%@",lDic[@"total"]];
        self.price = [NSString stringWithFormat:@"%@",lDic[@"price"]];
        self.priceUnit = [NSString stringWithFormat:@"%@",lDic[@"priceUnit"]];
        self.picUrl = [NSString stringWithFormat:@"%@",lDic[@"picUrl"]];
        self.longitude = [NSString stringWithFormat:@"%@",lDic[@"longitude"]];
        self.latitude = [NSString stringWithFormat:@"%@",lDic[@"latitude"]];
        self.distance = [NSString stringWithFormat:@"%@",lDic[@"distance"]];
    }
    return self;
}
@end

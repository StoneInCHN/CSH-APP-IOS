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
//        self.parkID = [NSString stringWithFormat:@"%@",lDic[@"parkID"]];
        self.name = [NSString stringWithFormat:@"%@",lDic[@"name"]];
        self.cityName = [NSString stringWithFormat:@"%@",lDic[@"cityName"]];
        self.areaName = [NSString stringWithFormat:@"%@",lDic[@"district"]];
        self.addr = [NSString stringWithFormat:@"%@",lDic[@"address"]];
//        self.leftNum = [NSString stringWithFormat:@"%@",lDic[@"leftNum"]];
//        self.total = [NSString stringWithFormat:@"%@",lDic[@"total"]];
//        self.price = [NSString stringWithFormat:@"%@",lDic[@"price"]];
//        self.priceUnit = [NSString stringWithFormat:@"%@",lDic[@"priceUnit"]];
//        self.picUrl = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],lDic[@"picUrl"]];
        self.longitude = [NSString stringWithFormat:@"%@",lDic[@"location"][@"lng"]];
        self.latitude = [NSString stringWithFormat:@"%@",lDic[@"location"][@"lat"]];
        self.distance = [NSString stringWithFormat:@"%@",lDic[@"distance"]];
        self.priceDesc = @"";
    }
    return self;
}
-(instancetype)initWithCarWashDic:(NSDictionary*)lDic{
    if (self = [super init]) {
        self.parkID = [NSString stringWithFormat:@"%@",lDic[@"cw_id"]];
        self.name = [NSString stringWithFormat:@"%@",lDic[@"name"]];
        self.priceDesc = [NSString stringWithFormat:@"%@",lDic[@"des"]];
        self.longitude = [NSString stringWithFormat:@"%@",lDic[@"lon"]];
        self.addr = [NSString stringWithFormat:@"%@",lDic[@"address"]];
        self.tel = [NSString stringWithFormat:@"%@",lDic[@"tel"]];
        self.distance = [NSString stringWithFormat:@"%@",lDic[@"mile"]];
        self.picUrl = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],lDic[@"pic"]];
        self.latitude = [NSString stringWithFormat:@"%@",lDic[@"lat"]];
        self.date = [NSString stringWithFormat:@"%@",lDic[@"date"]];
    }
    return self;
}
@end

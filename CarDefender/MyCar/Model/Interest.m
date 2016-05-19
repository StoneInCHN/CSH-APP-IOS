//
//  Interest.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Interest.h"

@implementation Interest
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.address = lDic[@"address"];
        self.cityName = lDic[@"cityName"];
        self.distance = lDic[@"distance"];
        self.district = lDic[@"district"];
        self.lat = lDic[@"location"][@"lat"];
        self.lng = lDic[@"location"][@"lng"];
        self.name = lDic[@"name"];
        self.type = lDic[@"type"];
    }
    return self;
}
@end

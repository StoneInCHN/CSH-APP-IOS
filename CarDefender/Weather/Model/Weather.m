//
//  Weather.m
//  weather
//
//  Created by 周子涵 on 15/7/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Weather.h"
#import "FutureWeather.h"

@implementation Weather
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.city = lDic[@"today"][@"city"];
        self.date = lDic[@"today"][@"date"];
        self.temp = lDic[@"today"][@"temp"];
        self.temperature = lDic[@"today"][@"temperature"];
        self.weather = lDic[@"today"][@"weather"];
        self.washIndex = lDic[@"today"][@"wash_index"];
        self.pm2_5 = lDic[@"today"][@"pm2_5"];
        self.pm2_5_State = lDic[@"today"][@"pm2_5State"];
        self.imageURL = lDic[@"today"][@"imageURL"];
        NSMutableArray* lMutArray = [NSMutableArray array];
        for (NSDictionary* dic in lDic[@"future"]) {
            FutureWeather* futureWeather = [[FutureWeather alloc] initWithDic:dic];
            [lMutArray addObject:futureWeather];
        }
        self.furtureArray = [NSArray arrayWithArray:lMutArray];
    }
    return self;
}
@end

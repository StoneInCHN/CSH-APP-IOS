//
//  FutureWeather.m
//  weather
//
//  Created by 周子涵 on 15/7/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "FutureWeather.h"

@implementation FutureWeather
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.temperature = lDic[@"temperature"];
        self.weather = lDic[@"weather"];
        self.week = lDic[@"week"];
        self.imageUrl = lDic[@"imageUrl"];
    }
    return self;
}
@end

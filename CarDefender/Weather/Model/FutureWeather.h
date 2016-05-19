//
//  FutureWeather.h
//  weather
//
//  Created by 周子涵 on 15/7/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FutureWeather : NSObject
@property (strong, nonatomic) NSString* week;            //日期
@property (strong, nonatomic) NSString* temperature;     //今日温度
@property (strong, nonatomic) NSString* weather;         //天气
@property (strong, nonatomic) NSString* imageUrl;        //图片
-(instancetype)initWithDic:(NSDictionary*)lDic;
@end

//
//  Weather.h
//  weather
//
//  Created by 周子涵 on 15/7/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property (strong, nonatomic) NSString* city;            //城市
@property (strong, nonatomic) NSString* date;            //日期
@property (strong, nonatomic) NSString* temp;            //当前温度
@property (strong, nonatomic) NSString* temperature;     //今日温度
@property (strong, nonatomic) NSString* weather;         //天气
@property (strong, nonatomic) NSString* washIndex;       //洗车指数
@property (strong, nonatomic) NSString* pm2_5;           //PM2.5值
@property (strong, nonatomic) NSString* pm2_5_State;     //PM2.5状态
@property (strong, nonatomic) NSString* imageURL;        //天气图片
@property (strong, nonatomic) NSArray*  furtureArray;    //未来5天

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end

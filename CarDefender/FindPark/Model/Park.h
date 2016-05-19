//
//  Park.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Park : NSObject
@property (strong, nonatomic) NSString* parkID;      //停车场唯一标示ID
@property (strong, nonatomic) NSString* name;        //停车场名称
@property (strong, nonatomic) NSString* cityName;    //所属城市名
@property (strong, nonatomic) NSString* areaName;    //所属区名
@property (strong, nonatomic) NSString* addr;        //停车场地址
@property (strong, nonatomic) NSString* leftNum;     //剩余车位
@property (strong, nonatomic) NSString* total;       //总车位
@property (strong, nonatomic) NSString* price;       //价格
@property (strong, nonatomic) NSString* priceUnit;   //价格单位
@property (strong, nonatomic) NSString* picUrl;      //停车场照片URL
@property (strong, nonatomic) NSString* longitude;   //经度
@property (strong, nonatomic) NSString* latitude;    //纬度
@property (strong, nonatomic) NSString* distance;    //距离
@property (strong, nonatomic) NSString* priceDesc;   //收费详情
@property (strong, nonatomic) NSString* tel;         //电话
@property (strong, nonatomic) NSString* date;        //营业时间

-(instancetype)initWithDic:(NSDictionary*)lDic;
-(instancetype)initWithCarWashDic:(NSDictionary*)lDic;
@end

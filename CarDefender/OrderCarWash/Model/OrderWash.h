//
//  OrderWash.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/25.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Park.h"

@interface OrderWash : NSObject
@property (strong, nonatomic) NSString* washID;      //停车场唯一标示ID
@property (strong, nonatomic) NSString* name;        //停车场名称
@property (strong, nonatomic) NSString* picUrl;      //停车场照片URL
@property (strong, nonatomic) NSString* addr;        //停车场地址
@property (strong, nonatomic) NSString* longitude;   //经度
@property (strong, nonatomic) NSString* latitude;    //纬度
@property (strong, nonatomic) NSString* distance;    //距离
@property (strong, nonatomic) NSString* priceDesc;   //收费详情
@property (strong, nonatomic) NSString* tel;         //电话
@property (strong, nonatomic) NSString* time;        //预约时间
@property (strong, nonatomic) NSString* uno;         //预约单号
@property (strong, nonatomic) NSString* date;        //营业时间

-(instancetype)initWithPark:(Park*)park;
-(instancetype)initWithDic:(NSDictionary*)lDic;
@end

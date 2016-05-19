//
//  CWSCarLocationDetailModel.h
//  CarDefender
//
//  Created by 李散 on 15/7/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSCarLocationDetailModel : NSObject
@property (strong, nonatomic) NSString* total;//总车位数
@property (strong, nonatomic) NSString* price;//单价
@property (strong, nonatomic) NSString* picUrl;//图片链接
@property (strong, nonatomic) NSString* areaName;//所属区
@property (strong, nonatomic) NSString* name;//停车场名字
@property (strong, nonatomic) NSString* cityName;//城市名
@property (strong, nonatomic) NSString* addr;//地址
@property (strong, nonatomic) NSString* priceUnit;//单位
@property (strong, nonatomic) NSString* leftNum;//可用数
@property (strong, nonatomic) NSString* priceDesc;//收费详情

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end

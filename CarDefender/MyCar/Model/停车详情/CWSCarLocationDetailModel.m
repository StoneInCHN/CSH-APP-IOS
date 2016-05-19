//
//  CWSCarLocationDetailModel.m
//  CarDefender
//
//  Created by 李散 on 15/7/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarLocationDetailModel.h"

@implementation CWSCarLocationDetailModel
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.total = lDic[@"total"];
        self.price = lDic[@"price"];
        self.picUrl = lDic[@"picUrl"];
        self.areaName = lDic[@"areaName"];
        self.name = lDic[@"name"];
        self.cityName = lDic[@"cityName"];
        self.addr = lDic[@"addr"];
        self.priceUnit = lDic[@"priceUnit"];
        self.leftNum = lDic[@"leftNum"];
        self.priceDesc = lDic[@"priceDesc"];
    }
    return self;
}
@end

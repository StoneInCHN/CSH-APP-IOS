//
//  MyOrderDetailModel.m
//  CarDefender
//
//  Created by 万茜 on 15/12/31.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "MyOrderDetailModel.h"

@implementation MyOrderDetailModel
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.add_time = lDic[@"add_time"];
        self.address = lDic[@"address"];
        self.effective_time = lDic[@"effective_time"];
        self.finished_time = lDic[@"finished_time"];
        self.goodsName = lDic[@"goodsName"];
        self.im_lat = lDic[@"im_lat"];
        self.im_lng = lDic[@"im_lng"];
        self.mobile = lDic[@"mobile"];
        self.orderGoodsList = lDic[@"orderGoodsList"];
        self.orderId = lDic[@"orderId"];
        self.order_sn = lDic[@"order_sn"];
        self.owner_name = lDic[@"owner_name"];
        self.reputation = lDic[@"reputation"];
        self.service_time = lDic[@"service_time"];
        self.status = [lDic[@"status"] integerValue];
        self.store_name = lDic[@"store_name"];
        self.image_1 = lDic[@"image_1"];
        self.barcodes = lDic[@"barcodes"];
    }
    return self;
}

@end

//
//  CWSHistoryOrder.m
//  CarDefender
//
//  Created by 周子涵 on 15/10/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSHistoryOrder.h"

@implementation CWSHistoryOrder

#if USENEWVERSION

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
//        effective_time:有效时间：
//        add_time：下单时间；
//        service_time：保养服务时间；
//        finished_time：完成时间；
        
        self.add_time = [NSString stringWithFormat:@"%@",dic[@"tenantName"]];
        self.amount_paid = [NSString stringWithFormat:@"%@",dic[@"price"]];
        if ([PublicUtils checkNSNullWithgetString:dic[@"buyer_email"]] != nil) {
            self.buyer_email = [NSString stringWithFormat:@"%@",[PublicUtils checkNSNullWithgetString:dic[@"buyer_email"]]];
        }
        if ([PublicUtils checkNSNullWithgetString:dic[@"evaluation_time"]] != nil) {
            self.evaluation_time = [NSString stringWithFormat:@"%@",[PublicUtils checkNSNullWithgetString:dic[@"evaluation_time"]]];
        }
        
        if ([PublicUtils checkNSNullWithgetString:dic[@"finished_time"]] != nil) {
            self.finished_time = [NSString stringWithFormat:@"%@",[PublicUtils checkNSNullWithgetString:dic[@"finished_time"]]];
        }
        self.goods_name = dic[@"carService"][@"serviceName"];
        self.orderId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.order_sn = [NSString stringWithFormat:@"%@",dic[@"carService"][@"id"]];
        if ([PublicUtils checkNSNullWithgetString:dic[@"carService"][@"serviceCategory"][@"modifyDate"]] != nil) {
            self.pay_time = [NSString stringWithFormat:@"%@",[PublicUtils checkNSNullWithgetString:dic[@"carService"][@"serviceCategory"][@"modifyDate"]]];
        }
        self.seller_id = [NSString stringWithFormat:@"%@",dic[@"carService"][@"serviceCategory"][@"id"]];
        self.seller_name = [NSString stringWithFormat:@"%@",dic[@"carService"][@"serviceCategory"][@"serviceCategory"]];
        self.service_time = dic[@"carService"][@"serviceCategory"][@"createDate"];
        self.status = [NSString stringWithFormat:@"%@",dic[@"chargeStatus"]];
        self.type = [NSString stringWithFormat:@"%@",dic[@"type"]];
        self.price = dic[@"price"];
        self.cate_id_2 = dic[@"cate_id_2"];
        self.classification_name = dic[@"carService"][@"serviceName"];
        
        
    }
    return self;
}

#else
-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        self.orderId = dic[@"id"];
        self.img = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],dic[@"img"]];
        self.name = dic[@"name"];
        self.uno = dic[@"uno"];
        self.plate = dic[@"plate"];
        self.date = dic[@"date"];
        self.deal = dic[@"deal"];
        self.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
    }
    return self;
}

#endif



@end

//
//  CWSCarWashDiscountModel.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarWashDiscountModel.h"

@implementation CWSCarWashDiscountModel

-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        
        NSMutableDictionary* realDict = [NSMutableDictionary dictionaryWithDictionary:lDic];
        for (NSString* key in [realDict allKeys]) {
            [realDict setValue:[PublicUtils checkNSNullWithgetString:[realDict valueForKey:key]] forKey:key];
        }
        
        self.productName = realDict[@"goods_name"];
        self.isRedPackageUseable = [realDict[@"support_red"] integerValue];
        self.discountPrice = realDict[@"discount_price"];
        
        self.originalPrice = realDict[@"price"];
//        self.productDetailName = lDic[@""];
        self.productID = [realDict[@"id"] integerValue];
        self.merchantsID = [realDict[@"store_id"] integerValue];
        self.merchantsName = realDict[@"store_name"];
        self.isDiscount = [realDict[@"is_discount_price"] integerValue];
        
    }
    return self;
}

@end

//
//  CWSPayInfoView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPayInfoView.h"

@implementation CWSPayInfoView

-(void)setDataDict:(NSDictionary *)dataDict{

    _dataDict = dataDict;
    
    self.storeNameLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"store_name"]];
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"goods_name"]];
    self.priceLabel.text = [dataDict[@"is_discount_price"] integerValue] ? [NSString stringWithFormat:@"￥%@",dataDict[@"discount_price"]] : [NSString stringWithFormat:@"￥%@",dataDict[@"price"]];
}

@end

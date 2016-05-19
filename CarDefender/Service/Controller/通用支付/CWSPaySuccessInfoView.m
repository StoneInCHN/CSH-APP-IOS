//
//  CWSPaySuccessInfoView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPaySuccessInfoView.h"

@implementation CWSPaySuccessInfoView


- (instancetype)initWithFrame:(CGRect)frame  Data:(NSDictionary *)dataDict
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CWSPaySuccessInfoView" owner:self options:nil] lastObject];
        self.frame = frame;
        
        
        self.storeNameLabel = (UILabel *)[self viewWithTag:1];
        self.storeNameLabel.text = dataDict[@"store_name"];
        
        self.productNameLabel = (UILabel *)[self viewWithTag:2];
        self.productNameLabel.text = dataDict[@"goods_name"];
        
        self.orderPriceLabel = (UILabel *)[self viewWithTag:3];
        self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",dataDict[@"price"]];
        
        self.orderIdLabel = (UILabel *)[self viewWithTag:4];
        self.orderIdLabel.text = dataDict[@"order_sn"];
        
        self.orderValidityPeriodLabel = (UILabel *)[self viewWithTag:5];
        self.orderValidityPeriodLabel.text = dataDict[@"effectiveTime"];
        
    }
    return self;
}

//-(void)setDataDict:(NSDictionary *)dataDict{
//    _dataDict = dataDict;
//    self.storeNameLabel.text = dataDict[@"store_name"];
//    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",dataDict[@"price"]];
//    self.orderIdLabel.text = dataDict[@"order_id"];
//    self.orderValidityPeriodLabel.text = dataDict[@"effectiveTime"];
//    self.productNameLabel.text = dataDict[@"goods_name"];
//    self.orderIdLabel.text = dataDict[@"order_sn"];
//}

@end

//
//  CWSPurchaseRecomCell.m
//  carLife
//
//  Created by MichaelFlynn on 12/2/15.
//  Copyright © 2015 王泰莅. All rights reserved.
//

#import "CWSPurchaseRecomCell.h"

@implementation CWSPurchaseRecomCell




-(void)setThyCommodityDict:(NSDictionary *)thyCommodityDict{
    _thyCommodityDict = thyCommodityDict;
    self.commodityId = [NSString stringWithFormat:@"%@",thyCommodityDict[@"service_id"]];
    self.purchaseTitleLabel.text = thyCommodityDict[@"serviceName"];
    NSString* priceString = @"";
//    if([thyCommodityDict[@"is_discount_price"] intValue]){
        priceString = thyCommodityDict[@"promotion_price"];
        self.discountLabel.text = [NSString stringWithFormat:@"￥%@",priceString];
        priceString = [NSString stringWithFormat:@"%@",thyCommodityDict[@"price"]];
        self.originalPriceLabel.text = priceString;
//    }else{
//        priceString = [NSString stringWithFormat:@"%@",thyCommodityDict[@"price"]];
//        self.originalPriceLabel.text = priceString;
//        self.discountLabel.text = [NSString stringWithFormat:@"￥%@",priceString];
//    }
    self.comfimLabel.layer.cornerRadius = 3;
    self.comfimLabel.layer.borderWidth = 1.0f;
    self.comfimLabel.layer.borderColor = kMainColor.CGColor;
    
//    self.redImageView.hidden = ![thyCommodityDict[@"support_red"] intValue];
    self.redImageView.hidden = YES;
}


- (IBAction)payClicked:(UIButton *)sender {
    
//    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:Red:ID:andDataDict:)]){
//        [self.delegate selectTableViewButtonClicked:sender Red:[self.thyCommodityDict[@"support_red"] integerValue] ID:[self.thyCommodityDict[@"id"] integerValue] andDataDict:self.thyCommodityDict];
//    }
    
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

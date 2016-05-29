//
//  CarMaintainTableViewCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "NewCarWashDiscountCell.h"

#import "CWSCarWashDiscountModel.h"
@implementation NewCarWashDiscountCell

-(void)setDiscountModel:(CWSCarWashDiscountModel *)discountModel{
    
    _discountModel = discountModel;
    
    
    [self.payButton setTitleColor:kMainColor forState:UIControlStateNormal];
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.borderColor = kMainColor.CGColor;
    self.payButton.layer.borderWidth = 1.0f;
    self.payButton.layer.cornerRadius = 5.0f;
    
    self.projectNameLabel.text = discountModel.productName;
    if(discountModel.productDetailName != nil){
        self.projectDetailNameLabel.textColor = KOrangeColor;
        self.projectDetailNameLabel.text = discountModel.productDetailName;
    }else{
        self.projectDetailNameLabel.hidden = YES;
    }
//    self.redPackageImageView.hidden = !discountModel.isRedPackageUseable;
    self.redPackageImageView.hidden = YES;
                 
    //是否有优惠价
    self.discountMessageLabel.hidden = NO;
    self.originalPriceLabel.hidden = NO;
    self.discountLineView.hidden = NO;
    
    self.discountPriceLabel.adjustsFontSizeToFitWidth = YES;
    NSString* priceString;
//    if(discountModel.isDiscount){
        priceString = discountModel.discountPrice;
        self.discountPriceLabel.text = [NSString stringWithFormat:@"￥%@",priceString];
        priceString = discountModel.originalPrice;
        self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",priceString];
//    }else {
//        priceString = [NSString stringWithFormat:@"￥%@",discountModel.originalPrice];
//        self.originalPriceLabel.text = priceString;
//        self.discountPriceLabel.text = priceString;
//      //  self.discountPriceLabelLead.constant += 33;
//    }
    
    if ([discountModel.merchantsName isEqualToString:@"保养"]) {
        [self.payButton setTitleColor:KOrangeColor forState:UIControlStateNormal];
        self.payButton.layer.borderColor = KOrangeColor.CGColor;
        [self.payButton setTitle:@"预约" forState:UIControlStateNormal];
    }
    
}


- (IBAction)firstButtonClicked:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:andDiscountModel:)]){
        [self.delegate selectTableViewButtonClicked:sender andDiscountModel:self.discountModel];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end

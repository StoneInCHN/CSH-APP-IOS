//
//  SFActivityTableViewCell.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/15.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFActivityTableViewCell.h"

@implementation SFActivityTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.discountCouponBtn.layer.borderWidth = 1;
    self.discountCouponBtn.layer.borderColor = [self.discountCouponBtn.currentTitleColor CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onDetailInfo:(id)sender {
    if (self.delegate) {
        [self.delegate onDetailInfo:self];
    }
}

- (IBAction)getDiscountCoupon:(id)sender {
    if (self.delegate) {
        [self.delegate getDiscountCoupon:self];
    }
}
@end

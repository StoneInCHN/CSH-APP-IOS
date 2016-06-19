//
//  SFActivityTableViewCell.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/15.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFActivityTableViewCell.h"
#import "SFActivityModel.h"
#import "SFWashCarModel.h"

@implementation SFActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.discountCouponBtn.layer.borderWidth = 1;
    self.discountCouponBtn.layer.borderColor = [self.discountCouponBtn.currentTitleColor CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setActivityModel:(SFActivityModel *)activityModel {
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",activityModel.amount];
    self.timeLabel.text = activityModel.deadlineTime;
    self.discountCouponCounter.text = [NSString stringWithFormat:@"%@",activityModel.remainNum];
    self.identify = [NSString stringWithFormat:@"%@",activityModel.identify];
    if ([activityModel.type isEqualToString: @"SPECIFY"]) {
        self.lightImageView.image = [UIImage imageNamed:@"redLightCoupon"];
        self.darkImageView.image = [UIImage imageNamed:@"redDarkCoupon"];
        self.typeLabel.text = @"指定优惠券";
    }
    if (activityModel.isGet) {
        [self.discountCouponCounter removeFromSuperview];
        [self.displayLabel removeFromSuperview];
        [self.displayLabel2 removeFromSuperview];
        self.discountCouponBtn.hidden = YES;
        self.couponSelectedImageView.hidden = NO;
    } else {
        if ([activityModel.remainNum isEqualToString:@"0"]) {
            [self.discountCouponCounter removeFromSuperview];
            [self.displayLabel removeFromSuperview];
            [self.displayLabel2 removeFromSuperview];
            self.discountCouponBtn.hidden = YES;
            self.couponSelectedImageView.hidden = NO;
            self.couponSelectedImageView.image = [UIImage imageNamed:@"coupon_no_one"];
        }
    }
}

- (void)setWashCarModel:(SFWashCarModel *)washCarModel {
    self.moneyLabel.text = [NSString stringWithFormat:@"%@次",washCarModel.remainNum];
    self.typeLabel.text = washCarModel.couponName;
    self.timeStaticLabel.text = washCarModel.tenantName;
    self.timeLabel.text = @"";
    self.identify = washCarModel.identify;
//    self.lightImageView.image = [UIImage imageNamed:@""];
//    self.darkImageView.image = [UIImage imageNamed:@""];
    [self.discountCouponCounter removeFromSuperview];
    [self.displayLabel removeFromSuperview];
    [self.displayLabel2 removeFromSuperview];
    self.discountCouponBtn.hidden = YES;
    self.couponSelectedImageView.hidden = NO;
    
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

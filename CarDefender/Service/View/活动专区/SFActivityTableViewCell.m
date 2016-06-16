//
//  SFActivityTableViewCell.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/15.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFActivityTableViewCell.h"
#import "SFActivityModel.h"


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
    }
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

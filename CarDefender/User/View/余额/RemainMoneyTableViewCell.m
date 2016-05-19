//
//  RemainMoneyTableViewCell.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "RemainMoneyTableViewCell.h"

@implementation RemainMoneyTableViewCell

- (void)awakeFromNib {
    self.titleLabel = (UILabel *)[self viewWithTag:1];
    self.dateLabel = (UILabel *)[self viewWithTag:2];
    self.moneyLabel = (UILabel *)[self viewWithTag:3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  PersonTitleTableViewCell.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "PersonTitleTableViewCell.h"

@implementation PersonTitleTableViewCell

- (void)awakeFromNib {
    self.titleLabel = (UILabel *)[self viewWithTag:1];
    self.messageLabel = (UILabel *)[self viewWithTag:2];
    self.arrowImageView = (UIImageView *)[self viewWithTag:3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  HeadMessageTableViewCell.m
//  MyAccountViewController
//
//  Created by 万茜 on 15/12/2.
//  Copyright © 2015年 万茜. All rights reserved.
//

#import "HeadMessageTableViewCell.h"

@implementation HeadMessageTableViewCell

- (void)awakeFromNib {
    self.headImage = (UIImageView *)[self viewWithTag:1];
    self.nameLabel = (UILabel *)[self viewWithTag:2];
    self.carLabel = (UILabel *)[self viewWithTag:3];
    self.montionLabel = (UILabel *)[self viewWithTag:4];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

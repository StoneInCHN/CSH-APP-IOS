//
//  PersonHeadTableViewCell.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "PersonHeadTableViewCell.h"

@implementation PersonHeadTableViewCell

- (void)awakeFromNib {
    self.headImageView = (UIImageView *)[self viewWithTag:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

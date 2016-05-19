//
//  AccountTableViewCell.m
//  MyAccountViewController
//
//  Created by 万茜 on 15/12/2.
//  Copyright © 2015年 万茜. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

- (void)awakeFromNib {
    self.headImage = (UIImageView *)[self viewWithTag:1];
    self.titleLabel = (UILabel *)[self viewWithTag:2];
    self.messageLabel = (UILabel *)[self viewWithTag:3];
}

- (void)loadData:(NSDictionary *)dic
{

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

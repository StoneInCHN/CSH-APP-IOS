//
//  CWSAlarmCell.m
//  CarDefender
//
//  Created by 李散 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAlarmCell.h"

@implementation CWSAlarmCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)swithValueChange:(UISwitch *)sender {
    [self.delegate swithValueChange:sender.on with:self.currentPath];
}
@end

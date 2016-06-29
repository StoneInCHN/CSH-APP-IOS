//
//  CWSSelectDeviceTableViewCell.m
//  CarDefender
//
//  Created by DRiPhion on 16/6/28.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSSelectDeviceTableViewCell.h"

@implementation CWSSelectDeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier NS_AVAILABLE_IOS(3_0){
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.shanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    self.shanghuLabel.textColor = kTextlightGrayColor;
    self.shanghuLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.shanghuLabel];
    
    self.deviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    self.deviceLabel.textColor = kTextlightGrayColor;
    self.deviceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.deviceLabel];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-1, self.frame.size.width-20, 1)];
    self.line.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    [self.contentView addSubview:self.line];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

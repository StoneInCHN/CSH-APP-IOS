//
//  CWSServiceBYTableViewCell.m
//  fghfghf
//
//  Created by DRiPhion on 16/6/18.
//  Copyright © 2016年 sujinjiu. All rights reserved.
//

#import "CWSServiceBYTableViewCell.h"

@implementation CWSServiceBYTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    self.byName= [[UILabel  alloc]initWithFrame:CGRectMake(20*kSizeOfScreen.width/375.0, 10, kSizeOfScreen.width-40*kSizeOfScreen.width/375.0, 20 )];
  
    self.byName.textAlignment = NSTextAlignmentLeft;
    self.byName.textColor = kMainColor;
    
    self.byPrice= [[UILabel  alloc]initWithFrame:CGRectMake(20*kSizeOfScreen.width/375.0, 10, kSizeOfScreen.width-40*kSizeOfScreen.width/375.0, 20 )];
    self.byPrice.textAlignment = NSTextAlignmentRight;
    self.byPrice.textColor = kMainColor;
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(20*kSizeOfScreen.width/375.0, self.frame.size.height-1, kSizeOfScreen.width-40*kSizeOfScreen.width/375.0, 1)];
    self.line.backgroundColor= [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    
    self.kuangView = [[UIView alloc]initWithFrame:CGRectMake(self.byName.frame.origin.x-5, self.byName.frame.origin.y-5, self.byName.frame.size.width+10, self.byName.frame.size.height+10)];
    self.kuangView.layer.cornerRadius = 5;
    
    [self.contentView addSubview:self.kuangView];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.byPrice];
    [self.contentView addSubview:self.byName];
    
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

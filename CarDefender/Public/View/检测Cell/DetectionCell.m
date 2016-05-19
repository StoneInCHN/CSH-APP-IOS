//
//  DetectionCell.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "DetectionCell.h"

@implementation DetectionCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setDicMsg:(NSDictionary *)dicMsg
{
    NSString*nameString;
    NSString*detailString;
    if ([dicMsg[@"type"] isEqualToString:@"1"]) {
        nameString = dicMsg[@"name"];
        detailString = dicMsg[@"value"];
    }else if ([dicMsg[@"type"] isEqualToString:@"2"]) {
        nameString = dicMsg[@"name"];
        detailString = dicMsg[@"value"];
    }else if([dicMsg[@"type"] isEqualToString:@"3"]) {
        nameString = dicMsg[@"name"];
        detailString = dicMsg[@"value"];
    }
    
    self.nameLabel.text = nameString;
    self.detailMsgLabel.text = detailString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

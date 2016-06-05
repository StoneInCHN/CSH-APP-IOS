//
//  IllegalCheckTableViewCell.m
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "IllegalCheckTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation IllegalCheckTableViewCell


-(void)setDicMsg:(NSDictionary *)dicMsg
{

    self.addressLabe.text = [PublicUtils checkNSNullWithgetString:dicMsg[@"illegalAddress"]];
//    self.headImageView.image = [UIImage imageNamed:@"logo"];
    self.carBrandLabel.text = [PublicUtils checkNSNullWithgetString:dicMsg[@"plate"]];
    self.illegalTimeLabel.text = [PublicUtils checkNSNullWithgetString:dicMsg[@"illegalDate"]];
    if ([dicMsg[@"finesAmount"] isKindOfClass:[NSNull class]]) {
        self.fineLabel.text = @"0";
    } else {
        self.fineLabel.text = [NSString stringWithFormat:@"%@",dicMsg[@"finesAmount"]];
    }
    if ([dicMsg[@"score"] isKindOfClass:[NSNull class]]) {
        self.pointLabel.text = @"0";
    } else {
        self.pointLabel.text = [NSString stringWithFormat:@"%@",dicMsg[@"score"]];
    }
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

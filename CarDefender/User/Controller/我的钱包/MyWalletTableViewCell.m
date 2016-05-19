//
//  MyWalletTableViewCell.m
//  CarDefender
//
//  Created by 万茜 on 15/12/16.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "MyWalletTableViewCell.h"

@implementation MyWalletTableViewCell

- (void)awakeFromNib {
    self.titleLabel = (UILabel *)[self viewWithTag:1];
    self.moneyLabel = (UILabel *)[self viewWithTag:2];
    self.messageLabel = (UILabel *)[self viewWithTag:3];
    self.headImageView = (UIImageView *)[self viewWithTag:4];
    
}

@end

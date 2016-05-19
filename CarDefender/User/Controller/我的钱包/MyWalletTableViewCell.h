//
//  MyWalletTableViewCell.h
//  CarDefender
//
//  Created by 万茜 on 15/12/16.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *messageLabel;//单位
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewHeight;

@end

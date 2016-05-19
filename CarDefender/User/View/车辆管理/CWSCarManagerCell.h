//
//  CWSCarManagerCell.h
//  CarDefender
//
//  Created by 李散 on 15/4/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCarManagerCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *carBrandImage;

@property (strong, nonatomic) IBOutlet UILabel *carNumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) IBOutlet UILabel *defaultLabel;

@property (strong, nonatomic) NSDictionary*dicMsg;
@end

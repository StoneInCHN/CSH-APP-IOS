//
//  DetectionCell.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetectionCell : UITableViewCell
@property (strong, nonatomic) NSDictionary *dicMsg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentMile;

@property (weak, nonatomic) IBOutlet UILabel *detailMsgLabel;
@end

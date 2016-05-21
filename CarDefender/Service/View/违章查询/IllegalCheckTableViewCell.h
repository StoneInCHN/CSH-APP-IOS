//
//  IllegalCheckTableViewCell.h
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllegalCheckTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabe;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;


@property (weak, nonatomic) IBOutlet UILabel *pointLabel;//扣分
@property (weak, nonatomic) IBOutlet UILabel *fineLabel;//罚款
@property (weak, nonatomic) IBOutlet UILabel *illegalTimeLabel;

@property (strong, nonatomic) NSDictionary*dicMsg;
@end

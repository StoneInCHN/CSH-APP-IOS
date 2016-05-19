//
//  CWSQueryCell.h
//  CarDefender
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSQueryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImg;
@property (weak, nonatomic) IBOutlet UILabel *carNub;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;

@end
